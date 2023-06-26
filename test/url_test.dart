import "package:flutter_test/flutter_test.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/logging.dart";

void main() {
  Logging.init();

  const apiStr = "https://api.mangadex.org";
  const id = "f9c33607-9180-4ba6-b85c-e4b5faee7192";

  test("URL creation with a single value.", () {
    final url = URL(hostname: "api.mangadex.org", pathSegments: ["manga"]);
    url.setParameter("id", id);

    final uri = url.toUri();
    expect(uri.toString(), "$apiStr/manga?id=$id");
  });

  test("URL creation with arrayed values.", () {
    final url = URL(hostname: "api.mangadex.org", pathSegments: ["manga"]);
    url.setParameter("ids[]", [id, id]);
    url.setParameter("includes[]", []);

    final uri = url.toUri();
    expect(uri.toString(), "$apiStr/manga?ids%5B%5D=$id&ids%5B%5D=$id");
  });

  test("URL creation with multiple complex values.", () {
    final url = URL(hostname: "api.mangadex.org", pathSegments: ["manga"]);
    url.setParameter("ids[]", [id, id]);
    url.setParameter("sort[title]", "asc");
    url.setParameter("limit", 100);
	url.setParameter("nullish", null);

    final uri = url.toUri();
    expect(
      uri.toString(),
      "$apiStr/manga?ids%5B%5D=$id&ids%5B%5D=$id&sort%5Btitle%5D=asc&limit=100",
    );
  });
  test("URL creation with custom type enums.", () {
    final url = URL(hostname: "api.mangadex.org", pathSegments: ["manga"]);
    url.setParameter("includes[]", [EntityType.artist, EntityType.author]);
    url.setParameter("status", MangaPublicationStatus.cancelled);
    url.setParameter("publicationDemographic", MangaPublicationDemographic.shounen);
    url.setParameter("contentRating", ContentRating.safe);

    final uri = url.toUri();
    expect(
      uri.toString(),
      "$apiStr/manga?includes%5B%5D=artist&includes%5B%5D=author"
      "&status=cancelled&publicationDemographic=shounen&contentRating=safe",
    );
  });

  test("Reference usage without modifying the original pointer.", () {
    final base = URL(hostname: "api.mangadex.org", pathSegments: ["manga"]);
    expect(base.toString(), "$apiStr/manga");

    final onId = base.clone().addPathSegment(id);
    final onIncludes = base.clone().setParameter("includes[]", ["chapters"]);
    final onIdIncludes = base.clone().addPathSegment(id).setParameter("includes[]", ["chapters"]);

    expect(base.toString(), "$apiStr/manga");
    expect(onId.toString(), "$apiStr/manga/$id");
    expect(onIncludes.toString(), "$apiStr/manga?includes%5B%5D=chapters");
    expect(onIdIncludes.toString(), "$apiStr/manga/$id?includes%5B%5D=chapters");
  });
}
