package moe.curstantine.riba.ui.common.dialogs

import android.content.Intent
import android.net.Uri
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.ClickableText
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.autofill.AutofillNode
import androidx.compose.ui.autofill.AutofillType
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalAutofill
import androidx.compose.ui.platform.LocalAutofillTree
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.DialogProperties
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.riba.RibaError
import moe.curstantine.riba.api.riba.RibaResult


// TODO: Make this a Material 3 compliant full-screen dialog when the API is out.
@Composable
fun AuthDialog(state: RibaHostState, isOpen: MutableState<Boolean>) = if (!isOpen.value) Unit else {
    val coroutineScope = rememberCoroutineScope()
    val error = MutableLiveData<RibaError>()

    val username = remember { mutableStateOf("") }
    val password = remember { mutableStateOf("") }

    AlertDialog(
        onDismissRequest = { isOpen.value = false },
        properties = DialogProperties(dismissOnClickOutside = false),
        text = { AuthDialogContent(coroutineScope, error, username, password) },
        title = { Text(stringResource(R.string.sign_in_to, stringResource(R.string.mangadex))) },
        dismissButton = {
            TextButton(
                onClick = { isOpen.value = false },
                content = { Text(stringResource(R.string.cancel)) })
        },
        confirmButton = {
            TextButton(
                enabled = username.value.isNotBlank() && password.value.isNotBlank(),
                content = { Text(stringResource(R.string._continue)) },
                onClick = {
                    coroutineScope.launch {
                        val resp = state.service.mangadex.user.login(
                            username.value,
                            password.value
                        )

                        if (resp is RibaResult.Error) {
                            error.postValue(resp.error)
                        } else {
                            isOpen.value = false
                        }
                    }
                },
            )
        }
    )
}


@Composable
private fun AuthDialogContent(
    coroutineScope: CoroutineScope,
    errorData: LiveData<RibaError>,
    username: MutableState<String>,
    password: MutableState<String>
) {
    val colorScheme = MaterialTheme.colorScheme
    val typography = MaterialTheme.typography

    val context = LocalContext.current
    val autofillContext = LocalAutofill.current
    val autofillTree = LocalAutofillTree.current

    val error = errorData.observeAsState()

    val forgotPasswordIntent = remember {
        Intent(Intent.ACTION_VIEW, Uri.parse(DexConstants.FORGOT_PASSWORD))
    }
    val createAccountIntent = remember {
        Intent(Intent.ACTION_VIEW, Uri.parse(DexConstants.CREATE_ACCOUNT))
    }

    // TODO: Learn how to add MangaDex host to autofill.
    val usernameAutofillNode = AutofillNode(
        autofillTypes = listOf(AutofillType.Username),
        onFill = { username.value = it }
    )
    val passwordAutofillNode = AutofillNode(
        autofillTypes = listOf(AutofillType.Password),
        onFill = { password.value = it }
    )

    autofillTree.plusAssign(usernameAutofillNode)
    autofillTree.plusAssign(passwordAutofillNode)

    Column(
        modifier = Modifier.verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        AnimatedVisibility(error.value != null) {
            Column(
                modifier = Modifier
                    .height(92.dp)
                    .fillMaxWidth()
                    .clip(shape = CardDefaults.shape)
                    .background(colorScheme.error),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                if (error.value != null) {
                    Text(
                        text = error.value!!.human,
                        style = typography.titleSmall.copy(color = colorScheme.onError),
                        textAlign = TextAlign.Center
                    )

                    Text(
                        text = error.value!!.additional ?: "",
                        style = typography.bodySmall.copy(
                            color = colorScheme.onError.copy(alpha = 0.75F)
                        ),
                        textAlign = TextAlign.Center
                    )
                }
            }
        }

        AnimatedVisibility(error.value == null) {
            Box(modifier = Modifier.height(92.dp), contentAlignment = Alignment.Center) {
                Text(
                    modifier = Modifier.padding(bottom = 2.dp),
                    text = stringResource(R.string.mangadex_sign_in_requirement),
                    style = typography.bodyMedium.copy(
                        color = colorScheme.onSurface.copy(alpha = 0.75F)
                    )
                )
            }
        }

        Box(
            Modifier.onGloballyPositioned { usernameAutofillNode.boundingBox = it.boundsInWindow() }
        ) {
            OutlinedTextField(
                value = username.value,
                label = { Text(stringResource(R.string.username)) },
                onValueChange = { username.value = it },
                modifier = Modifier.onFocusChanged {
                    autofillContext?.run {
                        if (it.isFocused) requestAutofillForNode(usernameAutofillNode)
                        else cancelAutofillForNode(usernameAutofillNode)
                    }
                },
            )
        }

        Box(
            Modifier.onGloballyPositioned { passwordAutofillNode.boundingBox = it.boundsInWindow() }
        ) {
            OutlinedTextField(
                value = password.value,
                label = { Text(stringResource(R.string.password)) },
                onValueChange = { password.value = it },
                modifier = Modifier.onFocusChanged {
                    autofillContext?.run {
                        if (it.isFocused) requestAutofillForNode(passwordAutofillNode)
                        else cancelAutofillForNode(passwordAutofillNode)
                    }
                },
            )
        }

        // TODO: Someday fix this godawful layout.
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 4.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            ClickableText(
                style = typography.labelMedium.copy(color = colorScheme.secondary),
                onClick = { coroutineScope.launch { context.startActivity(forgotPasswordIntent) } },
                text = AnnotatedString(stringResource(R.string.forgot_password))
            )
            Text(
                stringResource(R.string.or),
                style = typography.labelMedium.copy(color = colorScheme.secondary.copy(alpha = 0.35F))
            )
            ClickableText(
                style = typography.labelMedium.copy(color = colorScheme.secondary),
                onClick = { coroutineScope.launch { context.startActivity(createAccountIntent) } },
                text = AnnotatedString(stringResource(R.string.create_account))
            )
        }
    }
}

@Preview
@Composable
fun AuthDialogPreview() {
    AuthDialog(RibaHostState.createDummy(), remember { mutableStateOf(true) })
}