defmodule Monarchive.Subjects do
  alias Monarchive.Assets
  alias Monarchive.Assets.Asset
  alias Monarchive.Repo
  alias Monarchive.Subjects.Subject
  alias Monarchive.Subjects.SubjectParagraph

  def list do
    Subject
    |> Repo.all
    |> Enum.map(fn r -> Repo.preload(r, :header_asset) end)
  end

  def get(id) do
    Subject
    |> Repo.get(id)
    |> Repo.preload(:subject_paragraphs)
    |> Repo.preload(:header_asset)
    |> Repo.preload(:other_assets)
    |> Map.update(:subject_paragraphs, [], fn p_list -> Repo.preload(p_list, :asset) end)
    |> Map.update(:subject_paragraphs, [], fn p_list -> Enum.sort(p_list, &(&1.order < &2.order)) end)
  end

  def create(params \\ %{"name" => "New Subject", "paragraphs" => [%{"content" => "your content here", "header" => ""}]}) do
    with %Subject{} = subject <- %Subject{}
      |> Subject.changeset(Map.take(params, ["name", "description"]))
      |> Repo.insert!,
      params["paragraphs"]
      |> Enum.map(fn params ->
        %SubjectParagraph{}
        |> SubjectParagraph.changeset(Map.put(params, "subject_id", subject.id))
        |> Repo.insert!
      end) do
      {:ok, subject}
    else
      {:error, _error} = error ->
        error
    end
  end
  
  def update(%Subject{id: id, subject_paragraphs: old_sps} = subject, %{"paragraphs" => new_sps} = params) do
    if (params["header_asset_id"]) do
      Asset
      |> Repo.get(params["header_asset_id"])
      |> Asset.changeset(%{subject_id: id})
      |> Repo.update!
    end

    old_assets = old_sps
                 |> Repo.preload(:asset)
                 |> Enum.filter(&(!is_nil(&1.asset)))
                 |> Enum.map(&(Map.get(&1, :asset)))
    new_asset_ids = new_sps
                    |> Enum.filter(&(Map.has_key?(&1, "asset_id")))
                    |> Enum.map(&(String.to_integer(&1["asset_id"])))


    with subject
    |> Subject.changeset(Map.take(params, ["name", "description"]))
    |> Repo.update!,
    Enum.map(old_sps, fn sp -> Repo.delete(sp) end),
    Enum.map(new_sps, fn p ->
      subject_paragraph = %SubjectParagraph{}
      |> SubjectParagraph.changeset(Map.merge(p, %{"subject_id" => id}))
      |> Repo.insert!

      if Map.has_key?(p, "asset_id") do
        Asset
        |> Repo.get(p["asset_id"])
        |> Asset.changeset(%{subject_paragraph_id: subject_paragraph.id})
        |> Repo.update!
      end
    end),
    old_assets
    |> Enum.filter(fn %{id: id} -> id not in new_asset_ids end)
    |> Enum.map(&Assets.delete(&1))
    do
      {:ok, Repo.get(Subject, id)}
    end
  end

  def delete(id) do
    Subject
    |> Repo.get(id)
    |> Repo.delete
  end

  def checkout(id) do
    Subject
    |> Repo.get(id)
    |> Subject.changeset(%{checked_out_at: Time.utc_now()})
    |> Repo.update()
  end

  def checkin(id) do
    Subject
    |> Repo.get(id)
    |> Subject.changeset(%{checked_in_at: Time.utc_now()})
    |> Repo.update()
  end
end
