# Welcome to Translatron!
**##!BETA  VERSION - NOT FOR LIVE OR PROD USAGE!**

# Description
Comming soon...

# Usage
Comming soon...

## Initilazion
#### Basic Initilazion
```dart
    void  main() async {
		await  Translatron.init(
			hostname:  "https://example.com",
			versionPath:  "/api/translation/version",
			translationsPath:  "/api/translation/translations",
		);
	]);
```
#### Initilazion with custom supported languages
```dart
    void  main() async {
		await  Translatron.init(
			hostname:  "https://example.com",
			versionPath:  "/api/translation/version",
			translationsPath:  "/api/translation/translations",
			supportedLocales:  const [
				Locale('hu'),
				Locale('en'),
			],
		);
	]);
```
	
#### Initilazion with custom supported languages and custom api headers
```dart
    void  main() async {
		await  Translatron.init(
			hostname:  "https://example.com",
			versionPath:  "/api/translation/version",
			translationsPath:  "/api/translation/translations",
			supportedLocales: const [
				Locale('hu'),
				Locale('en'),
			],
			apiHeaders: const {
				"Authorization" : "Bearer $token",
				"Content-Type: application/json"
			}
		);
	]);
```
	
#### Add the custom delegate to app
```dart
return  MaterialApp.router(
	title:  'DemoApp',
	localizationsDelegates:  const [
		Translatron.delegate,
		GlobalMaterialLocalizations.delegate,
		GlobalWidgetsLocalizations.delegate,
		GlobalCupertinoLocalizations.delegate,
	],
	//To change to your state management
	locale: Provider.of<LocaleProvider>(context,  listen:  true).getlocale, 
	supportedLocales:  Translatron.getSupportedLocales,
);
```

#### Demo provider
```dart
class  LocaleProvider  with  ChangeNotifier {
	Locale?  locale  =  Translatron.getSelectedLanguageLocale;
	
	Locale?  get  getlocale {
		return  locale;
	} 

	void  changeLocale(Locale  newLocale) {
		locale  =  newLocale;
		Translatron.setSelectedLanguageLocale  =  locale!;
		notifyListeners();
	}
}
```

#### Language change with provider
```dart
Provider.of<LocaleProvider>(context,  listen:  false)
.changeLocale(const  Locale('hu',  'HU'));
```

## Functions
#### Translate, returns string
```dart
Translatron.of(context)!.translate("translation.key");
```
#### Return if language is active, returns bool
```dart
Translatron.isLanguageActice('en');
```

#### Returns the supported locales in **List of Locale**
```dart
Translatron.getSupportedLocales;
```

#### Returns the selected Language Locale, in some cases nullable
```dart
Translatron.getSelectedLanguageLocale;
```

#### Sets the selected Language Locale, in some cases nullable
```dart
Translatron.setSelectedLanguageLocale  =  locale!;
```