import 'dart:convert';
import 'dart:io';

void main() {
  final enFile = File('lib/l10n/app_en.arb');
  final amFile = File('lib/l10n/app_am.arb');

  final enMap = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final amMap = jsonDecode(amFile.readAsStringSync()) as Map<String, dynamic>;

  final newEn = {
    "chatMessagesTitle": "Messages",
    "chatSecureMessaging": "Secure Messaging",
    "chatNoMessages": "No messages to show yet",
    "chatNoMessagesYet": "No messages yet",
    "chatMessageSendError": "Your message couldn't be sent. Please check your connection.",
    "chatPendingMessageNotice": "Messaging will be enabled once the provider accepts your request.",
    "chatClosedMessageNoticePrefix": "Messaging is closed for this ",
    "chatClosedMessageNoticeSuffix": " booking.",
    "chatTypeMessageHint": "Type a message...",
    "chatWaitingForAcceptanceHint": "Waiting for provider acceptance..."
  };

  final newAm = {
    "chatMessagesTitle": "መልዕክቶች",
    "chatSecureMessaging": "ደህንነቱ የተጠበቀ መልእክት",
    "chatNoMessages": "እስካሁን ምንም መልዕክቶች የሉም",
    "chatNoMessagesYet": "እስካሁን ምንም መልዕክቶች የሉም",
    "chatMessageSendError": "መልዕክትዎ መላክ አልቻለም። እባክዎ ግንኙነትዎን ያረጋግጡ።",
    "chatPendingMessageNotice": "አቅራቢው ጥያቄዎን አንዴ ከተቀበለ በኋላ መልዕክት መላላክ ይቻላል።",
    "chatClosedMessageNoticePrefix": "ለዚህ ",
    "chatClosedMessageNoticeSuffix": " የተደረገ ቦታ ማስያዣ መልዕክት መላላክ ተዘግቷል።",
    "chatTypeMessageHint": "መልዕክት ይጻፉ...",
    "chatWaitingForAcceptanceHint": "የአቅራቢውን ተቀባይነት በመጠበቅ ላይ..."
  };

  enMap.addAll(newEn);
  amMap.addAll(newAm);

  enFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(enMap));
  amFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(amMap));
}
