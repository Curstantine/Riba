import "package:flutter_test/flutter_test.dart";
import "package:riba/repositories/url.dart";

void main() {
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

    final uri = url.toUri();
    expect(uri.toString(), "$apiStr/manga?ids%5B%5D=$id&ids%5B%5D=$id");
  });

  test("URL creation with multiple complex values.", () {
    final url = URL(hostname: "api.mangadex.org", pathSegments: ["manga"]);
    url.setParameter("ids[]", [id, id]);
    url.setParameter("sort[title]", "asc");
    url.setParameter("limit", 100);

    final uri = url.toUri();
    expect(
      uri.toString(),
      "$apiStr/manga?ids%5B%5D=$id&ids%5B%5D=$id&sort%5Btitle%5D=asc&limit=100",
    );
  });
}
