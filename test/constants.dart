const mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192";
const coverId = "d3b3a942-6cf4-4fa4-a9f4-627d8b361f8f";
const coverFile = "c18da525-e34f-4128-a696-4477b6ce6827.png";
const authorOrArtistId = "26f72ab8-a251-4286-ba6d-a38e164f1c72";
const title = "Official \"Test\" Manga";
const groupName = "Baumkuchen Scans";
const authorName = "Deka Ore";

const mangaIds = [
  "d473d946-e086-454a-9cb4-62d14f8491da",
  "fed16739-b4fc-447a-9e2f-36cf61ea1908",
  // This title is pornographic, and should be empty for
  // requests that don't include the pornographic filter.
  "9fd3b55f-7646-41fa-be01-55086c0b562d",
  "0d115e4f-a1b9-467d-a99b-d551254c3fd7",
  "89393959-9749-4b7d-b199-cf25f1a52d86",
  "be27727f-25e8-4743-8c67-68ed94b817be",
  "cc4d6e0e-bb54-4d50-b364-9e52e1a6c962",
  "70f068b7-3afa-46ce-be2a-1b818740c7a6",
  "b5db2828-e1ac-4fa4-baa0-0727294c221b",
  "283b5da5-59e2-460e-ba59-84db3a887b31",
  "379bc27b-99a8-4786-a0a6-2749a63d442c",
  "026e6baa-6ff1-4f58-9921-114abf82977a",
  "9f5899a0-2b30-4feb-a7c8-bd4be85fe58a",
  "74ea9c74-87b5-48c1-b0dd-4e56722c13bb",
  "e8606e09-ae02-44fd-83d7-401b929932b0",
  "b1b20403-c861-4865-8cbe-3d3b39f176c5",
  "018a3a94-e806-4f70-8f47-6205f98108b2",
  "5ecadf1a-d2b1-494c-bd0a-d3bf4a50abf0",
  "a76543f7-d46f-4347-947f-5119795b4c1b",
  "ed0fd97a-9684-4be8-98b3-08fc0b9bde30",
  "b3583a62-1184-4a61-b18e-9497a81b1673",
  "d032cdeb-1ced-4031-8b9e-45e6064c1781",
  "2a3fd052-01d3-4903-88a3-13d1d095823e",
  "6b958848-c885-4735-9201-12ee77abcb3c",
  "d0c60a11-0106-45cf-abfc-d131cb49868f",
  "2e0fdb3b-632c-4f8f-a311-5b56952db647",
  "523dbd43-2033-45a3-a15c-aafd9c4c16ec",
  "77bee52c-d2d6-44ad-a33a-1734c1fe696a",
  "a77742b1-befd-49a4-bff5-1ad4e6b0ef7b",
  "b4c93297-b32f-4f90-b619-55456a38b0aa",
  "4141c5dc-c525-4df5-afd7-cc7d192a832f",
  "bdb64c74-cfc5-4a78-98ee-4dfcfd3f3343",
  "5a90308a-8b12-4a4d-9c6d-2487028fe319",
  "8eefd034-8fa2-44f6-b962-e5d54757479a",
  "6033535e-ea6a-4f52-9d81-17101a739c33",
  "9f73bd5e-30a8-4ba6-a276-c7a58d368a09",
  "19a107f1-7e6e-487e-8ab0-19c2618d9cd2",
  "d58eb211-a1ae-426c-b504-fc88253de600",
  "d7037b2a-874a-4360-8a7b-07f2899152fd",
  "77fd8118-61b0-4b1f-95a6-2b839d754f81",
  "34e45b02-b5c8-4a4b-a21a-7b5059391dc8",
  "3d521799-62fc-4fb1-95b7-b39caa9a442c",
  "e55a7036-1479-48aa-8127-942698de9530",
  "8847f905-550d-4fe6-bcda-ac2b896789c7",
  "596191eb-69ee-4401-983e-cc07e277fa17",
  "4f3bcae4-2d96-4c9d-932c-90181d9c873e",
  "ea9cfac2-fd05-4c13-8fee-0dc732388f88",
  "736a2bf0-f875-4b52-a7b4-e8c40505b68a",
  "003e7fbf-f047-4783-a7df-1533a2a653d4",
  "7c3abdf7-902e-4cf6-8037-26eac2d606a8",
  "6b9206b3-5c0f-4cf8-a0cc-d2c9e1aa4df9",
  "a8bd2f1b-0bbb-4803-a551-3ca54788ddb8",
  "801513ba-a712-498c-8f57-cae55b38cc92",
  "239d6260-d71f-43b0-afff-074e3619e3de"
];

const chapterIds = [
  "0aaf8b27-0013-4ae0-8935-91a089466874",
  "bbf176a0-ea53-4b8b-8e23-8aa192e838d5",
  "aff0e720-88f2-45c5-8d9e-817f84d4c306",
  "dfc5a5cc-8b36-4f0c-a272-ae69802c91f8",
  "68b3cde2-0acd-4e4b-9842-780c301852c1",
  "da9e3b05-c2b6-430d-b97f-0c825098a22c",
  "a321ba6c-f723-434f-8119-5b898e86980a",
  "96ce3263-6e8d-42c7-8c70-9871cc7365d4",
  "317f6c2f-095d-4de4-aee1-111224db8f22",
  "7c03d00c-55f5-4370-bb00-8bc3dafee36c"
];

const groupIds = [
  "a408e049-2d88-429f-8c03-f0cc8ab2325c",
  "1adb76cd-dead-4f15-831b-dd7a793c42f5",
];
