import Foundation
import RegexBuilder

let frontitudeRawJson = ##"""
{
  "source": {
    "recco_bookmarks_empty_state_title": "You haven't created any bookmarks yet",
    "recco_bookmarks_title": "Your Bookmarks",
    "recco_continue_button": "Continue",
    "recco_dashboard_alert_mental_wellbeing_body": "How you feel influences your thoughts and your behaviors, so let's help you feel good more often!",
    "recco_dashboard_alert_mental_wellbeing_title": "Mental Health",
    "recco_dashboard_alert_nutrition_body": "How you eat the majority of the time affects your long-term health, so let's make healthy eating easier!",
    "recco_dashboard_alert_nutrition_title": "Eating Behavior",
    "recco_dashboard_alert_physical_activity_body": "Your activity levels affect your mood and body, so let's get you moving in ways that are fun and sustainable!",
    "recco_dashboard_alert_physical_activity_title": "Physical Activity",
    "recco_dashboard_alert_sleep_body": "Optimal sleep balances your hormones and improves your mental and physical health. Let's help you sleep better each night!",
    "recco_dashboard_alert_sleep_title": "Sleep",
    "recco_dashboard_explore_topic": "Explore & Learn: {{section_name}}",
    "recco_dashboard_new_for_you": "New for You",
    "recco_dashboard_recommended_for_you_topic": "Recommended For You: {{section_name}}",
    "recco_dashboard_review_area": "Load",
    "recco_dashboard_start_here": "Quick Wins!",
    "recco_dashboard_trending": "Popular Articles",
    "recco_dashboard_unlock": "Unlock it",
    "recco_dashboard_welcome_back_body": "Let's see how we can improve your health today...",
    "recco_dashboard_welcome_back_title": "Great to see you!",
    "recco_dashboard_you_may_also_like": "Totally You",
    "recco_error_connection_body": "Please check your network connection and try again. ",
    "recco_error_connection_title": "No Connection",
    "recco_error_generic_body": "Hmmm... we're not sure what happened. Please check your network connection and go back.",
    "recco_error_generic_title": "Something's Amiss",
    "recco_error_reload": "Reload",
    "recco_finish_button": "Finish",
    "recco_next": "Next",
    "recco_onboarding_go_to_dashboard": "Go to dashboard",
    "recco_onboarding_outro_body": "You've finished setting up your profile. \nNow let’s see what Recco has for you!",
    "recco_onboarding_outro_title": "Great job!",
    "recco_onboarding_page1_body": "Welcome to Recco, the personalized health improvement tool. \n \nComplete surveys to get customized health advice for improving your life all around!",
    "recco_onboarding_page1_title": "Well hello there!",
    "recco_onboarding_page2_body": "Let's talk about you! \n\nWhat's important to you? What are your health goals? And how are you doing right now?",
    "recco_onboarding_page2_title": "All About You",
    "recco_onboarding_page3_body": "The more surveys you complete, the more accurate your health score and customized health recommendations will be. \nYou'll also get fun and interesting content to help you make positive changes right away!",
    "recco_onboarding_page3_title": "Let's Grow Together",
    "recco_questionnaire_about_you": "All About You",
    "recco_questionnaire_go_to_dashboard": "Go to Dashboard",
    "recco_questionnaire_multiple_answers": "Multiple answers possible",
    "recco_questionnaire_numeric_label_cm": "cm.",
    "recco_questionnaire_numeric_label_ft": "ft.",
    "recco_questionnaire_numeric_label_in": "in.",
    "recco_questionnaire_numeric_label_kg": "kg.",
    "recco_questionnaire_numeric_label_lb": "lb.",
    "recco_questionnaire_numeric_label_min": "min.",
    "recco_questionnaire_numeric_label_st": "st.",
    "recco_questionnaire_outro_body": "Keep going! The more questionnaires you complete, the more accurate your health score will be. \nThen, Recco can make personalized recommendations for you to make real health improvements.",
    "recco_questionnaire_outro_title": "Great! You finished the {{section_name}} section.",
    "recco_start": "Start"
  },
  "de": {
    "recco_bookmarks_empty_state_title": "Du hast noch keine Lesezeichen gesetzt.",
    "recco_bookmarks_title": "Deine Bookmarks",
    "recco_continue_button": "Weiter",
    "recco_dashboard_alert_mental_wellbeing_body": "Deine Gefühlswelt nimmt Einfluss auf Deine Gedanken und Dein Verhalten. Finde Wege, dich öfter besser zu fühlen.",
    "recco_dashboard_alert_mental_wellbeing_title": "Mentale Gesundheit",
    "recco_dashboard_alert_nutrition_body": "Deine Gesundheit hängt auch davon ab, wie Du dich im Großen und Ganzen ernährst. So geht gesundes Essen ganz einfach:",
    "recco_dashboard_alert_nutrition_title": "Essverhalten",
    "recco_dashboard_alert_physical_activity_body": "Regelmäßige körperliche Aktivität wirkt sich positiv auf Körper und Geist aus - besonders, wenn die Bewegung Spaß macht!",
    "recco_dashboard_alert_physical_activity_title": "Bewegung",
    "recco_dashboard_alert_sleep_body": "Guter Schlaf ist das Fundament physischer und mentaler Gesundheit. Zum Glück kannst Du Deine Schlafqualität beeinflussen.",
    "recco_dashboard_alert_sleep_title": "Schlaf",
    "recco_dashboard_explore_topic": "Entdecken & verstehen: {{section_name}}",
    "recco_dashboard_new_for_you": "Neue Inhalte",
    "recco_dashboard_recommended_for_you_topic": "Für dich empfohlen: {{section_name}}",
    "recco_dashboard_review_area": "Bereich \nvertiefen",
    "recco_dashboard_start_here": "Schnell zum Erfolg",
    "recco_dashboard_trending": "Beliebte Tipps",
    "recco_dashboard_unlock": "Freischalten",
    "recco_dashboard_welcome_back_body": "Mal sehen, was Deiner Gesundheit heute guttun könnte...",
    "recco_dashboard_welcome_back_title": "Willkommen!",
    "recco_dashboard_you_may_also_like": "Speziell für dich",
    "recco_error_connection_body": "Nimm dir eine kleine Auszeit und versuche es später nochmal.",
    "recco_error_connection_title": "Keine Verbindung",
    "recco_error_generic_body": "Irgendwas ist schief gegangen. Überprüfe bitte Deine Netzwerkverbindung und lade die Seite neu.",
    "recco_error_generic_title": "Oh nein!",
    "recco_error_reload": "Neu laden",
    "recco_finish_button": "Abschließen",
    "recco_next": "Weiter",
    "recco_onboarding_go_to_dashboard": "Zum Dashboard",
    "recco_onboarding_outro_body": "Du hast Dein Profil erfolgreich eingerichtet. Schau dir jetzt an, was Recco dir zu bieten hat.",
    "recco_onboarding_outro_title": "Prima!",
    "recco_onboarding_page1_body": "Willkommen bei Recco, Deinem ganz persönlichen Hilfsmittel für mehr Gesundheit im Alltag. Beantworte Fragen und Du bekommst Tipps für ein rundum gesünderes Leben!",
    "recco_onboarding_page1_title": "Schön, dass Du da bist!",
    "recco_onboarding_page2_body": "Genug über Recco... und zu dir. Was ist dir wichtig? Wie sehen Deine Gesundheitsziele aus? Und wie geht es dir im Moment?",
    "recco_onboarding_page2_title": "Im Fokus: Du!",
    "recco_onboarding_page3_body": "Je mehr Fragen Du beantwortest, umso aussagekräftiger wird Dein Gesundheits-Index. Der Content wird genau auf dich abgestimmt. So macht positive Veränderung Spaß!",
    "recco_onboarding_page3_title": "Gemeinsam wachsen",
    "recco_questionnaire_about_you": "Im Fokus: Du!",
    "recco_questionnaire_go_to_dashboard": "Zum Dashboard",
    "recco_questionnaire_multiple_answers": "Mehrfachauswahl möglich",
    "recco_questionnaire_numeric_label_cm": "cm",
    "recco_questionnaire_numeric_label_ft": "ft.",
    "recco_questionnaire_numeric_label_in": "in.",
    "recco_questionnaire_numeric_label_kg": "kg",
    "recco_questionnaire_numeric_label_lb": "lb.",
    "recco_questionnaire_numeric_label_min": "Min.",
    "recco_questionnaire_numeric_label_st": "st.",
    "recco_questionnaire_outro_body": "Du hast alle Fragen zu{{section_name}}beantwortet und damit noch bessere Empfehlungen für dich generiert. Schau sie dir gleich an!",
    "recco_questionnaire_outro_title": "Super gemacht!",
    "recco_start": "Los geht's!"
  },
  "es": {}
}
"""##

let matchUntilClose = Regex {
    NegativeLookahead("}}")
    One(.any)
}

let getVariable = Regex {
    One("{{")
    OneOrMore(matchUntilClose)
    One("}}")
}

let getDynamicVariables = Regex {
    OneOrMore(getVariable)
}

func parseJsonStringsAndTransformToIos(json: String) -> [String] {
    var files = [String]()
    let jsonDict = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: [String: String]]
    let langKeys = jsonDict.keys
    for lang in langKeys {
        var file: String = ""
        let newDict = jsonDict[lang]!
        let keys = newDict.keys.sorted(by: <)
        for k in keys {
            let v = newDict[k]!
            let escapedReturnsValue = v.replacingOccurrences(of: "\n", with: #"\n"#)
            let matches = escapedReturnsValue.matches(of: getDynamicVariables)
            let dynamicVariablesReplaced = matches.reduce(escapedReturnsValue) { partialResult, match in
                partialResult.replacingCharacters(in: match.range, with: "%@")
            }.trimmingCharacters(in: .whitespacesAndNewlines)

            file.append(
                ##""\##(k)" = "\##(dynamicVariablesReplaced)";"##
            )
            file.append("\n")
        }
        files.append(file)
    }
    return files
}

let result = parseJsonStringsAndTransformToIos(json: frontitudeRawJson)
let (one, two, three) = (result[0], result[1], result[2])
one
two
three
