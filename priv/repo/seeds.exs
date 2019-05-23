# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Monarchive.Repo.insert!(%Monarchive.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

#
# Records
#

records = %{}

records = Map.put(records, :october_revolution, Monarchive.Repo.insert!(%Monarchive.Records.Record{
  name: "October Revolution",
  description: "A revolution in Russia led by the Bolshevik Party of Vladimir Lenin that was instrumental in the larger Russian Revolution of 1917."
}))

records = Map.put(records, :death_of_dostoevsky, Monarchive.Repo.insert!(%Monarchive.Records.Record{
  name: "Death of Fyodor Dostoevsky",
  description: "The great author Fyodor Dostoevsky has died. Literature and human consciousness suffers a great loss on this day."
}))

Monarchive.Repo.insert!(%Monarchive.Records.RecordParagraph{
  header: "What was the October Revolution?",
  content: "At first, the event was referred to as the October coup (Октябрьский переворот) or the Uprising of 3rd, as seen in contemporary documents (for example, in the first editions of Lenin's complete works). In Russian, however, \"переворот\" has a similar meaning to \"revolution\" and also means \"upheaval\" or \"overturn\", so \"coup\" is not necessarily the correct translation. With time, the term October Revolution (Октябрьская революция) came into use. It is also known as the \"November Revolution\" having occurred in November according to the Gregorian Calendar.",
  record_id: records.october_revolution.id
})

Monarchive.Repo.insert!(%Monarchive.Records.RecordParagraph{
  header: "How did Fyodor Dostoevsky die?",
  content: "On 25 January 1881, while searching for members of the terrorist organisation Narodnaya Volya (\"The People's Will\") who would soon assassinate Tsar Alexander II, the Tsar's secret police executed a search warrant in the apartment of one of Dostoevsky's neighbours. On the following day, Dostoevsky suffered a pulmonary haemorrhage. Anna denied that the search had caused it, saying that the haemorrhage had occurred after her husband had been looking for a dropped pen holder. After another haemorrhage, Anna called the doctors, who gave a poor prognosis. A third haemorrhage followed shortly afterwards. While seeing his children before dying, Dostoevsky requested that the parable of the Prodigal Son be read to his children.",
  record_id: records.death_of_dostoevsky.id
})

#
# Subjects
#

subjects = %{}

subjects = Map.put(subjects, :dostoevsky, Monarchive.Repo.insert!(%Monarchive.Subjects.Subject{
  name: "Fyodor Dostoevsky",
  description: "Russian novelist, short story writer, essayist, journalist and philosopher"
}))

subjects = Map.put(subjects, :tbk, Monarchive.Repo.insert!(%Monarchive.Subjects.Subject{
  name: "The Brothers Karamazov",
  description: "The Brothers Karamazov is the final novel by the Russian author Fyodor Dostoevsky."
}))

Monarchive.Repo.insert!(%Monarchive.Subjects.SubjectParagraph{
  header: "The Works of Fyodor Dostoevsky",
  content: "Dostoevsky's literary works explore human psychology in the troubled political, social, and spiritual atmospheres of 19th-century Russia, and engage with a variety of philosophical and religious themes. His most acclaimed works include Crime and Punishment (1866), The Idiot (1869), Demons (1872) and The Brothers Karamazov (1880). Dostoevsky's oeuvre consists of 11 novels, three novellas, 17 short stories and numerous other works. Many literary critics rate him as one of the greatest psychologists in world literature.[3] His 1864 novella Notes from Underground is considered to be one of the first works of existentialist literature.",
  subject_id: subjects.dostoevsky.id
})

Monarchive.Repo.insert!(%Monarchive.Subjects.SubjectParagraph{
  header: "Context and Background",
  content: "Although Dostoevsky began his first notes for The Brothers Karamazov in April 1878, he had written several unfinished works years earlier. He would incorporate some elements into his future work, particularly from the planned epos The Life of a Great Sinner, which he began work on in the summer of 1869. It eventually remained unfinished after Dostoevsky was interested in the Nechayev affair, which involved a group of radicals murdering one of their former members. He picked up that story and started with Demons. The unfinished Drama in Tobolsk (Драма. В Тобольске) is considered the first draft of the first chapter of The Brothers Karamazov. Dated 13 September 1874, it tells of a fictional murder in Staraya Russa committed by a praporshchik named Dmitry Ilynskov (based on a real soldier from Omsk), who is thought to have murdered his father. It goes on noting that his body was suddenly discovered in a pit under a house. The similarly unfinished Sorokoviny (Сороковины), dated 1 August 1875, is reflected in book IX, chapter 3–5 and book XI, chapter nine.",
  subject_id: subjects.tbk.id
})

