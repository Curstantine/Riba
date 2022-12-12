package moe.curstantine.riba.api.adapters.retrofit

import moe.curstantine.riba.BuildConfig
import okhttp3.Interceptor
import okhttp3.Response

class ClientInfoInterceptor : Interceptor {
	override fun intercept(chain: Interceptor.Chain): Response {
		val appAgent = "Riba (${BuildConfig.VERSION_CODE})"

		val priorChain = chain.request()
		val request = priorChain.newBuilder()
			.header("User-Agent", appAgent)

		return chain.proceed(request.build())
	}
}