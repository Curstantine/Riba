import "package:http/http.dart";

class SelfClient extends BaseClient {
  final Client _inner;
  final String userAgent;

  SelfClient(this._inner, this.userAgent);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers["User-Agent"] = userAgent;
    return _inner.send(request);
  }
}
