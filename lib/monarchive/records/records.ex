defmodule Monarchive.Records do
  alias Monarchive.Assets
  alias Monarchive.Assets.Asset
  alias Monarchive.Records.{Record, RecordParagraph, RecordRelationship}
  alias Monarchive.Subjects.Subject
  alias Monarchive.Repo

  def list do
    Record
    |> Repo.all
    |> Enum.map(fn r -> Repo.preload(r, :header_asset) end)
  end

  def get(id) do
    Record
    |> Repo.get(id)
    |> Repo.preload(:record_paragraphs)
    |> Repo.preload(:header_asset)
    |> Repo.preload(:other_assets)
    |> Map.update(:record_paragraphs, [], fn p_list -> Repo.preload(p_list, :asset) end)
    |> Map.update(:record_paragraphs, [], fn p_list -> Enum.sort(p_list, &(&1.order < &2.order)) end)
  end

  def create(params \\ %{"name" => "New Record", "paragraphs" => [%{"content" => "your content here", "header" => ""}]}) do
    with %Record{} = record <- %Record{}
      |> Record.changeset(Map.take(params, ["name", "description"]))
      |> Repo.insert!,
      params["paragraphs"]
      |> Enum.map(fn params ->
        %RecordParagraph{}
        |> RecordParagraph.changeset(Map.put(params, "record_id", record.id))
        |> Repo.insert!
      end) do
      {:ok, record}
    else
      {:error, _error} = error ->
        error
    end
  end
  
  def update(%Record{id: id, record_paragraphs: old_rps} = record, %{"paragraphs" => new_rps} = params) do
    if (params["header_asset_id"]) do
      Asset
      |> Repo.get(params["header_asset_id"])
      |> Asset.changeset(%{record_id: id})
      |> Repo.update!
    end

    old_assets = old_rps
                 |> Repo.preload(:asset)
                 |> Enum.filter(&(!is_nil(&1.asset)))
                 |> Enum.map(&(Map.get(&1, :asset)))
    new_asset_ids = new_rps
                    |> Enum.filter(&(Map.has_key?(&1, "asset_id")))
                    |> Enum.map(&(String.to_integer(&1["asset_id"])))

    with record
    |> Record.changeset(Map.take(params, ["name", "description"]))
    |> Repo.update!,
    Enum.map(old_rps, fn rp -> Repo.delete(rp) end),
    Enum.map(new_rps, fn p ->
      record_paragraph = %RecordParagraph{}
      |> RecordParagraph.changeset(Map.merge(p, %{"record_id" => id}))
      |> Repo.insert!

      if Map.has_key?(p, "asset_id") do
        Asset
        |> Repo.get(p["asset_id"])
        |> Asset.changeset(%{record_paragraph_id: record_paragraph.id})
        |> Repo.update!
      end
    end),
    old_assets
    |> Enum.filter(fn %{id: id} -> id not in new_asset_ids end)
    |> Enum.map(&Assets.delete(&1))
    do
      {:ok, Repo.get(Record, id)}
    end
  end

  def link_record_to_subject(%Record{id: record_id}, %Subject{id: subject_id}) do
    %RecordRelationship{}
    |> RecordRelationship.changeset(%{record_id: record_id, subject_id: subject_id})
    |> Repo.insert!()
  end

  # TODO implement
  #def unlink_record_from_subject(%Record{id: record_id}, %Subject{id: subject_id}) do
  #  RecordRelationship
  #  |> where(record_id: ^record_id)
  #  |> where(subject_id: ^subject_id)
  #  |> Repo.one()
  #  |> Repo.delete()
  #end

  def delete(id) do
    Record
    |> Repo.get(id)
    |> Repo.delete
  end
end
