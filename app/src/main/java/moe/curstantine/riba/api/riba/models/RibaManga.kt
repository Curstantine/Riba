package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexContentRating

/**
 * Generalized Manga object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "manga")
data class RibaManga(
    @PrimaryKey val id: String,
    @ColumnInfo val title: String?,
    @ColumnInfo val altTitles: List<String>?,
    @ColumnInfo val description: String?,
    @ColumnInfo val contentRating: DexContentRating,
    @ColumnInfo val artistIds: List<String>,
    @ColumnInfo val authorIds: List<String>,
    @ColumnInfo val tagIds: List<String>,
    @ColumnInfo val coverId: String?,
    /**
     * Version that increments when the manga is updated.
     * Can be used to check if the manga needs to be updated in the database.
     */
    @ColumnInfo val version: Int,
) {
    companion object {
        fun getDefault() = RibaManga(
            id = "9c33607-9180-4ba6-b85c-e4b5faee7192",
            title = "Official \"Test\" Manga",
            altTitles = listOf("TEST", "刃直海角骨入"),
            description = "From the creator of popu***l***ar ser***i***es like ***T***wo Pi***e***ce, Da***r***uto, ***a***nd Detergent, comes the series Test, an award winning romantic comedy about a high schoo***l*** weapon meister named Yugi as he trave***l***s the entire world collecting all the Life Notes, so that one da***y*** ***h***e can recover h***i***s bro***t***her's body after performing the taboo of one punching the Titan we saw that day with his Stand and becoming the Nokage Pirate King -dattebayo. Watch as he roams through the Ho***l***y ***E***mpi***r***e of Britannia with his Onii-chan and generic harem girls as they conquer all odds with the power of friendship, love and…(why don't they just bang each other.) In this feature length epic rivaling that of Gilgamesh and the Iliad we will explore the mentality and sociology of these societal menaces as they ravage the Earth in their never quenchable thirst for imoutos.  \n\nReviewers gives this series a 10/10 for the unconventional portrayal of the magical girl genre.  \nNominated for the 1st Mangadex Award for Worst Manga of the Year.  \nWinner of the 2nd Mangadex Awards for Best Manga of the Year.  \nBest manga ever written, as stated by meichiro noda  \n\n---\n**Note:** Please do *NOT* add genres or Test will pollute genre searches. Because this manga is the most purest form of any manga [The plural of manga is manga]  \n  \n**Fun fact:** In the year 127, when this manga was originally released, it used to be called Taest, but because of American per/letter printing costs it was shortened to Test.  \n\n---\n\n“Umm… so, personally… this is the first time this has happened, so I'm a bit surprised. Only a centimeter away… I mean, I don't think there's ever been someone who's gotten that close to me… without a, you know… calamity occurring. I'm not really… not really sure what happens at one centimeter away… 'cause it's my first time. I don't really understand it either. Seriously. But in the flow of calamity… there's nobody who can attack me. Not a single person. That, I know for sure. Wonder of U.” - Unknown   \n  \n\"Thanos kills Dumbledore\" - Anonymous Reviewer  \n  \n\"Like zoinks, man it's Mr Bombastic.\" - Shaggy  \n  \n\"DEUS VULT!!\" - Knight Templars  \n  \n\"There are zombies on my Lawn\" - Crazy Astel  \n  \n\"I FINALLY HAVE A F*CKING NOSE\" - Lord Coco  \n  \n\"NOOOOOOOOOOOOOOOOOOOO!!!!!!!!!!!!!!!!!!!!\" - Darth Vader  \n  \n\"The turtles! *They're everywhere!*\" - #8699  \n  \n\"Who's Rem?\" - Subaru Impreza  \n  \n\"I approb\" - Oozora Subaru  \n  \n \"PURGE THE HERETICS\" - The Space Marines  \n  \n![WHOAAAAAA](<https://i.ibb.co/dM9yv89/WHOAAAAAA.gif>)  \n  \n![EHE](<https://media1.tenor.com/images/fdcd995c9db4af798c2daa4380c79a8c/tenor.gif>)  \n  \n![HEH](<https://cdn.discordapp.com/emojis/650248281091342346.png>)\n  \nI have so many questions.\n\nTest2\n\n---\n- [YumGumYum](https://mangadex.org/user/3678de43-a55d-43be-b2ab-5c32a8219021/yumgumyum) **:**\n\n      remind me to write something here\n\n- [Tristan](https://mangadex.org/user/01642be8-72b8-48ae-9199-d8c747946ca5) **:**\n\n      @YumGumYum reminder",
            contentRating = DexContentRating.Safe,
            artistIds = listOf(
                "8043e940-169a-497e-b76d-422d653b42fb",
                "fc343004-569b-4750-aba0-05ab35efc17c"
            ),
            authorIds = listOf("fc343004-569b-4750-aba0-05ab35efc17c"),
            tagIds = listOf(),
            coverId = "d3b3a942-6cf4-4fa4-a9f4-627d8b361f8f",
            version = 0
        )
    }
}