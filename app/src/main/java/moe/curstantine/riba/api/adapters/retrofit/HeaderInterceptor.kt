package moe.curstantine.riba.api.adapters.retrofit


import android.util.Log
import moe.curstantine.riba.api.riba.RibaError
import okhttp3.Interceptor
import okhttp3.Response

class HeaderInterceptor(
	private val tag: RibaError.Companion.LogTag
) : Interceptor {
	override fun intercept(chain: Interceptor.Chain): Response {
		val request = chain.request()
		val response = chain.proceed(request)
		val token = response.header("X-Request-ID")
		val path = request.url.toString()

		if (token != null) {
			Log.i(tag.tag, "X-Request-ID: $token for $path")
		} else {
			Log.w(tag.tag, "X-Request-ID not found for $path")
		}

		return response
	}
}