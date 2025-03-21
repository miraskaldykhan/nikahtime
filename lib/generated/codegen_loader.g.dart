// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> ru = {
    "app_locale": "ru",
    "usersScreen": {
      "tittle": "Пользователи",
      "loading": "Подождите, идет загрузка профилей пользователей",
      "searchNotFound":
          "К сожалению, мы не нашли пользователей по Вашему запросу",
      "searchHint": "Введите строку для поиска",
      "searchMainHint":
          "Для поиска пользователей необходимо в строке поиска ввести имя или фамилию",
      "notFound": "К сожалению, тут пока еще никого нет",
      "match": {
        "male":
            "{firstName} тоже вами интересуется!\nВы можете написать первым.",
        "female":
            "{firstName} тоже вами интересуется!\nВы можете написать первой.",
        "": "{firstName} тоже вами интересуется!\nМожете начать общение."
      },
      "writeMessage": "Написать сообщение",
      "continueViewing": "Продолжить просмотр",
      "selectedForYou": "Подобрано для вас",
      "favorites": "Понравившиеся",
      "youFavorite": "Вы понравились",
      "liked": "Я понравился"
    },
    "user": {
      "hide": "Скрыть",
      "more": "Подробнее",
      "firstName": "Имя",
      "lastName": "Фамилия",
      "age": "Возраст",
      "yearsCount": {
        "zero": "{} лет",
        "one": "{} год",
        "two": "{} года",
        "few": "{} года",
        "many": "{} лет",
        "other": "{} лет"
      },
      "gender": {"title": "Пол", "male": "Мужской", "female": "Женский"},
      "interests": "Интересы",
      "aboutMe": "О себе",
      "education": "Образование",
      "placeOfStudy": "Место учебы",
      "birthDate": "Дата рождения",
      "country": "Страна проживания",
      "city": "Город",
      "contactPhoneNumber": "Контактный номер телефона",
      "placeOfWork": "Место работы",
      "workPosition": "Должность",
      "maritalStatus": "Семейное положение",
      "faith": "Возможность переезда",
      "canons": "Вера",
      "haveChildren": {
        "title": "Дети",
        "hint": "Есть ли дети?",
        "yes": "Есть",
        "no": "Нет"
      },
      "badHabits": "Вредные привычки",
      "nationality": "Национальность",
      "photos": "Фотографии"
    },
    "filters": {
      "tittle": "Фильтры",
      "complicatedFilterTittle": "Кто вам интересен?",
      "reset": "Сбросить",
      "close": "Закрыть",
      "isOnline": "Сейчас онлайн",
      "simpleFilter": "Простой фильтр",
      "complicatedFilter": "Расширенный фильтр",
      "from": "От",
      "to": "До",
      "maritalStatusTitle": "Интересуемое семейное положение",
      "educationTitle": "Интересуемое образование",
      "find": "Подобрать"
    },
    "profileScreen": {
      "title": "Профиль",
      "generalInformation": "Основная информация",
      "settings": {
        "header": "Настройки",
        "subscription": {
          "header": "Подписка",
          "type": {
            "header": "Тип: ",
            "no": "Отсутствует",
            "unlimited": "Бессрочный",
            "trial": "Тестовый период",
            "1_month": "1 месяц",
            "3_months": "3 месяца",
            "6_months": "6 месяцев"
          },
          "subscribe": "Оформить",
          "expires": "Истекает: "
        },
        "language": {
          "header": "Язык приложения",
          "text": "Приложение на английском"
        },
        "common": "Общие положения",
        "privacy": "Политика конфиденциальности",
        "agreement": "Пользовательское соглашение",
        "useTerms": "Правила пользования приложением",
        "paymentRules": "Правила оплаты",
        "refundRules": "Политика возвратов",
        "tariffs": "Тарифы",
        "refund": "Гарантии возврата",
        "help": "Помощь",
        "error": {
          "header": "Ошибка",
          "text": "Не найден почтовый клиент. Наша почта: nikahtime@bk.ru"
        },
        "mail": "Наша почта: nikahtime@bk.ru\n",
        "connectToDevs": "Написать разработчикам",
        "exit": "Выйти",
        "deleteAccount": "Удалить аккаунт",
        "deleteAccountAlert": {
          "cancel": "Отменить",
          "header": "Удалить аккаунт?",
          "confirm": "Удалить",
          "msg": "Все данные акканута будут удалены."
        },
        "about": "О нас",
        "psychologists": "Психологи",
        "directors": "Директор центра создания и сохранения семьи NikahTime",
        "associateDirectors": "Помощник Директора по связям с общественностью",
        "hazrats": "Хазраты",
        "curators": "Куратор проекта NikahTime",
        "psychologist_single": "Психолог",
        "shariaJudge": "Шариатский судья",
        "link": "Открыть в VK",
        "link_second": "Открыть в WhatsApp",
        "price": "Стоимость консультации продолжительностью до 60 минут",
        "donate_msg": {
          "header": "Поддержать проект",
          "text":
              "Дорогой пользователь, если ты сделаешь Садака (пожертвование), то эти средства пойдут на то, чтобы сделать этот мир добрее! А также на развитие и поддержку проекта NikahTime!",
          "text2": "Спасибо тебе! Ты помогаешь нам сделать этот мир лучше! ",
          "later_btn": "Позже",
          "support_btn": "Поддержать"
        },
        "theme": {
          "header": "Тема",
          "tiffani": "Тиффани",
          "pinkClouds": "Розовые облака"
        },
        "notifications": "Уведомления",
        "family_consultation": "Семейная консультация",
        "change_photo": "Изменить фотографию",
        "donate_msg_text":
            "Ассаламу алейкум ва РахматуЛлахи ва баракатуху и доброго времени суток, уважаемый пользователь! Цель приложения  NikahTime заключается в том, чтобы каждый желающий по милости Аллаха обрёл человеческое счастье и нашёл свою вторую половику! У тебя есть возможность поучаствовать в этом благом деле и помочь приложению NikahTime стать лучше, сделав садака (пожертвование) на номер карты 2202 2032 5291 7218. Эти деньги мы собираем для разработки и выпуска новой версии NikahTime!",
        "text_copied": "Номер карты скопирован",
        "phone_copied": "Номер телефона скопирован"
      }
    },
    "paymentScreen": {
      "tittle": "Подписки",
      "promo": "СУПЕР АКЦИЯ",
      "paymentButton": "Оформить подписку",
      "paymentDone": "Подписка оформлена",
      "daysCount": {
        "zero": "{} дней",
        "one": "{} день",
        "two": "{} дня",
        "few": "{} дня",
        "many": "{} дней",
        "other": "{} дней"
      },
      "monthsCount": {
        "zero": "{} мес.",
        "one": "{} мес.",
        "two": "{} мес.",
        "few": "{} мес.",
        "many": "{} мес.",
        "other": "{} мес."
      },
      "tariffDescription": "Расширенные возможности приложения на",
      "feature1": "Неограниченное количество доступных для просмотра анкет",
      "feature2": "Возможность выражать симпатию понравившимся людям",
      "feature3": "Возможность вести общение внутри приложения",
      "feature4": "Просмотр взаимных симпатий и посетителей Вашего профиля",
      "continue": "Продолжить",
      "paymentMethod": "Способ оплаты",
      "paymentMethodCard": "Банковская карта",
      "emailForReceiptTitle": "Эл. почта для квитанции",
      "emailForReceiptError": {
        "emailRequired": "Необходимо указать эл. почту для квитанции",
        "emailInvalid": "Эл. почта указана некорректно"
      },
      "error": {
        "title": "Ошибка",
        "closeButton": "Закрыть",
        "unknown":
            "К сожалению, покупка недоступна по неизвестной причине. Пожалуйста, попробуйте позже.",
        "clientInvalid":
            "Покупка не может быть совершена, попробуйте сменить аккаунт или устройство.",
        "paymentCancelled": "Вы отменили покупку.",
        "paymentInvalid":
            "Покупка отклонена. Пожалуйста, проверьте платёжные данные и убедитесь, что на счету достаточно средств.",
        "paymentNotAllowed":
            "Покупка недоступна для выбранного платёжного метода. Пожалуйста, убедитесь, что Ваш платёжный метод позволяет оплачивать покупки в интернете.",
        "storeProductNotAvailable":
            "Данный продукт недоступен в вашем регионе. Пожалуйста, смените магазин и повторите попытку.",
        "cloudServicePermissionDenied": "Покупка отклонена.",
        "cloudServiceNetworkConnectionFailed":
            "Покупка не может быть совершена, потому что устройство оффлайн. Пожалуйста, попробуйте ещё раз при стабильном подключении к интернету.",
        "cloudServiceRevoked": "Покупка отклонена.",
        "privacyAcknowledgementRequired":
            "Покупка не может быть совершена, поскольку вы не согласились с условиями использования AppStore. Пожалуйста, подтвердите согласие в настройках и вернитесь к покупке.",
        "unauthorizedRequestData":
            "Возникла ошибка. Пожалуйста, вернитесь к покупке позже.",
        "invalidOfferIdentifier": "Промо-предложение недействительно.",
        "invalidSignature":
            "Извините, возникла ошибка при использовании промо-кода. Пожалуйста, попробуйте позже.",
        "missingOfferParams":
            "Извините, возникла ошибка при использовании промо-предложения. Пожалуйста, попробуйте позже.",
        "invalidOfferPrice":
            "Извините, покупка невозможна. Попробуйте повторить её позже.",
        "verifyError":
            "Извините, возникла ошибка покупки. Средства будут возвращены через 3 дня, если подписка не активируется.",
        "verifyAppStoreError":
            "Извините, возникла ошибка покупки. Средства будут возвращены через 3 дня, если подписка не активируется.",
        "duplicateProductObject":
            "Активация подписки в обработке. Средства будут возвращены через 3 дня, если подписка не активируется."
      }
    },
    "tariffs": {
      "description":
          "Одни из основных целей приложения NikahTime - это ускорить процесс поиска второй половики, поженить и выдать замуж максимальное количество желающих людей",
      "header": "Функционал премиум подписки:",
      "option1":
          "Отображение количества просмотров историй одним и тем же человеком",
      "option2": "Отображение времени просмотра сторис",
      "option3": "Анонимный просмотр сторис",
      "option4": "Возможность анонимного чтение смс",
      "option5":
          "Возможность просмотра времени последнего посещения пользователей",
      "option6": "Возможность размещения сторис",
      "option7": "Настраиваемая функция невидимки для посещения пользователей",
      "button": "Подписаться за 169 руб./мес.",
      "canCancel": "Отключить можно в любое время",
      "alertTitle":
          "Отличная новость! У вас уже есть доступ к премиум-функциям.",
      "alertContent":
          "Эта акция действует только в течение месяца. Вы уже пользуетесь премиум-возможностями нашего приложения. Спасибо, что остаетесь с нами!"
    },
    "googleOrApple": {
      "signUp": "или зарегистрироваться с помощью",
      "login": "или зарегистрироваться с помощью"
    },
    "common": {
      "online": "В сети",
      "offline": "Не в сети",
      "videoWaitBox": "Подождите, идет загрузка видео",
      "apply": "Применить",
      "takePhoto": "Сделать снимок на камеру",
      "getPhoto": "Выбрать фото из галереи",
      "takeVide": "Записать видео с камеры",
      "getVideo": "Загрузить видео из галереи",
      "delete": "Удалить",
      "errorHintText": "Необходимо заполнить это поле",
      "phoneNumberHint": "Введите название страны или ее код",
      "selectOptions": "Выберите варианты",
      "confirm": "Подтвердить",
      "cancel": "Отменить",
      "change": "Изменить",
      "notSet": "Не указано",
      "setCountry": "Выберите страну",
      "setMaritalStatus": "Выберите семейное положение",
      "setCountryAndCode": "Введите название страны или ее код",
      "chooseOptions": "Выберите варианты",
      "vizited_q": "Кто заходил ко мне?",
      "vizited": "Заходили ко мне",
      "usingPhoneNumberHint": "Номер телефона будет виден только Вам",
      "payment": {
        "alert": {
          "titleForView": "Больше возможностей с подпиской",
          "titleForAction": "Больше возможностей с подпиской",
          "detail":
              "Только сейчас подписка по цене чашки кофе☕️\nНе упусти возможность найти свою вторую половинку!",
          "moreButton": "Подробнее",
          "notNowButton": "Не сейчас"
        }
      },
      "fieldNotRequired": "(необязательно)"
    },
    "educationList": {
      "basicGeneral": "Основное общее",
      "secondaryGeneral": "Среднее общее",
      "secondaryVocational": "Среднее профессиональное",
      "higherBachelorOrSpecialist": "Высшее (бакалавр, специалист)",
      "higherMaster": "Высшее (магистр)",
      "academicDegree": "Ученая степень"
    },
    "nationalityState": {"notSelected": "Не указано"},
    "familyState": {
      "notMarried": "Не женат / не замужем",
      "married": "Женат / замужем",
      "divorced": "В разводе"
    },
    "observantOfTheCanonsFemaleState": {
      "observingIslamCanons": "Cоблюдающая каноны ислама \nмусульманка",
      "nonObservingIslamCanons": "Cоблюдаю религиозные обряды \nпо праздникам"
    },
    "observantOfTheCanonsMaleState": {
      "observingIslamCanons": "Cоблюдающий каноны ислама \nмусульманин",
      "nonObservingIslamCanons": "Cоблюдаю религиозные обряды \nпо праздникам"
    },
    "islam": "Ислам",
    "christianity": "Христианство",
    "judaism": "Иудаизм",
    "another": "Другая",
    "any":"Любое",
    "religionSubtitle": "Конфессиональная принадлежность",
    "contacts": "Контакты",
    "contact": {
      "not_registered": "There are no registered contacts",
      "access_denied": "Access is denied",
      "error": "An error has occurred"
    },
    "faithState": {
      "observantMuslim": "Готов/а к переезду",
      "nonObservantMuslim": "Не готов/а к переезду",
      "notSelected": "Не указано"
    },
    "childrenState": {"yes": "Есть", "no": "Нет"},
    "badHabbits": {
      "smoking": "Курение",
      "alcohol": "Алкоголь",
      "gambling": "Игровая зависимость",
      "other_h": "Другое",
      "missing": "Отсутствуют"
    },
    "interestTag": {
      "walks": "Прогулки",
      "sport": "Спорт",
      "cinema": "Кино",
      "yoga": "Йога",
      "food": "Еда",
      "tourism": "Туризм",
      "leisure": "Активный отдых",
      "swimming": "Бассейн",
      "crossFit": "Кроссфит",
      "bicycle": "Велосипед",
      "animals": "Животные",
      "comedy": "Комедия",
      "love": "Любовь"
    },
    "claim": {
      "toReport": "Пожаловаться",
      "claimReason": {
        "propaganda": "Пропаганда вражды и разжигание ненависти",
        "misleading": "Введение в заблуждение",
        "promo": "Рекламные материалы",
        "bulling": "Оскорбление",
        "adults": "Материалы для взрослых",
        "spam": "Спам",
        "finance": "Финансовые услуги"
      },
      "description":
          "Мы рассмотрим жалобу в течение 24 часов и, если будет обнаружено нарушение, примем необходимые меры для его пресечения.",
      "send": "Отправить",
      "reason": "Выберите причину для жалобы",
      "comment": "Комментарий"
    },
    "chat": {
      "cancelButtonText": "Понятно",
      "attentionHeader": "Внимание",
      "attentionText": "Ваш профиль заблокирован.",
      "waitbox": "Подождите, идет загрузка чата",
      "main": {
        "header": "Чаты",
        "find": "Поиск по чату",
        "you": "Вы: ",
        "min": "мин.",
        "hour": "ч.",
        "day": "дн.",
        "now": "сейчас",
        "lastTimeOnline": {"prefix": "Был(а) ", "postfix": " назад"}
      },
      "del": {
        "cancel": "Отменить",
        "header": "Внимание",
        "confirm": "Подтвердить",
        "alert": "Внимание",
        "msg": "Вы действительно хотите удалить выбранный чат"
      },
      "file": "Файл",
      "img": "Изображение",
      "video": "Видео",
      "bottom": {
        "img": {
          "take": "Сделать фото на камеру",
          "get": "Выбрать фото из галереи"
        },
        "video": {
          "take": "Записать видео на камеру",
          "get": "Выбрать видео из галереи"
        },
        "file": "Выбрать файл из хранилища"
      },
      "blocked": "Отправка сообщений ограничена",
      "fileWaitBox": "Идет загрузка вложения",
      "block": "Заблокировать",
      "unblock": "Разблокировать",
      "delete": "Удалить диалог",
      "report": "Пожаловаться"
    },
    "welcome_screen": {
      "createAcc": "Создать аккаунт",
      "ageConfirmed": {
        "question": "Вам есть 18?",
        "bad": "Мне ещё нет 18",
        "good": "Мне есть 18",
        "action": "Для продолжения подвердите свой возраст."
      },
      "alreadyLogged": "Уже есть аккаунт? ",
      "authorize": "Войти",
      "carousel": {
        "item1": {
          "header": "Удобные фильтры",
          "text":
              "Настраивайте фильтры и находите только\nтех, кто Вам нравится"
        },
        "item2": {
          "header": "Только люди",
          "text":
              "Наше приложение проводит тщательную\nпроверку, не пропуская ни одного бота"
        },
        "item3": {
          "header": "Общайтесь",
          "text": "Общайтесь в удобном и простом чате\nс понравившимися людьми"
        }
      }
    },
    "registration": {
      "header": "Регистрация",
      "appendix": {
        "text": "Регистрируясь, вы соглашаетесь\nс ",
        "item1": "Политикой конфиденциальности",
        "and": " и ",
        "item2": "Пользовательским соглашением"
      },
      "sendCode": "Отправить код",
      "type": {
        "message": "или зарегистрируйтесь с помощью",
        "phone": {
          "by": "По номеру телефона",
          "header": "Мой номер",
          "text":
              "Пожалуйста, введите ваш актуальный номер телефона. Мы отправим вам звонок для подтверждения вашей учетной записи. Нужно будет ввести 4 последние цифры номера телефона который вам звонил.",
          "hintPass": "Придумайте пароль",
          "hintSecPass": "Повторите пароль",
          "error":
              "Пользователь с таким номером телефона уже существует. Если это Вы - пройдите процедуру восстановления пароля",
          "nextScreenMessage": "указанный номер телефона"
        },
        "email": {
          "by": "По адресу E-mail",
          "header": "Мой E-mail",
          "text":
              "Пожалуйста, введите ваш действующий Email адрес. Мы отправим вам 6-значный код для подтверждения вашей учетной записи.",
          "hintMail": "Введите Email",
          "hintPass": "Придумайте пароль",
          "hintSecPass": "Повторите пароль",
          "error":
              "Пользователь с таким Email-адресом уже существует. Если это Вы - пройдите процедуру восстановления пароля",
          "nextScreenMessage": "указанный электронный адрес"
        }
      },
      "PIN": {
        "header": "PIN",
        "action": "Продолжить",
        "message": "{} отправлен на {}:\n {}",
        "sendAgain": "Отправить код повторно"
      },
      "error": {
        "msg": "Проверьте правильность введенных данных и повторите попытку",
        "diffPass": "Введенные пароли не совпадают.",
        "badPass": "Пароль должен быть длиной не менее 8 символов",
        "badPIN": "Введен некорректный код",
        "maxLength": "Максимально допустима длина 25 символов"
      },
      "profile": {
        "header": "Создание профиля",
        "educationHint": "Выберите Ваше образование"
      },
      "interest": {
        "header": "Твои интересы",
        "subheader":
            "Добавьте минимум 5 интересов, чтобы мы могли подобрать более подходящих людей",
        "addNew": "Добавить свой"
      },
      "about": {
        "header": "О себе",
        "subheader":
            "Напиши немного информации о себе. Так тебе будут писать больше людей.",
        "example":
            "Например: У меня высшее образование, по утрам гуляю с собакой, в свободное время хожу в кино."
      }
    },
    "entering": {
      "error": {
        "dataType":
            "Проверьте правильность введенных данных и повторите попытку\nПример номера: +79998887766 или 79998887766\nПример email-адреса: address@mailbox.domain",
        "nouser":
            "Запрашиваемого пользователя не существует или пароль введен неверно. Проверьте правильность введенных данных и повторите запрос.",
        "badEmail":
            "Введен некорректный email-адрес. Проверьте правильность ввода и повторите запрос.\nПример корректного mail-адреса: xxx@xxx.xx",
        "badNumber":
            "Введен некорректный номер. Проверьте правильность ввода и повторите запрос.\n"
      },
      "main": {
        "header": "Вход",
        "divider": "или войдите с помощью",
        "hintData": "Введите Email или номер телефона",
        "hintPass": "Введите пароль",
        "hintRecPass": "Забыли пароль?",
        "enter": "Войти"
      },
      "recoveryBy": {
        "email": {
          "hint": "Введите Email",
          "get": "Получить код",
          "header": "Восстановление пароля",
          "msg":
              "Введите свой Email и вам на почту придет письмо с кодом для восстановления пароля"
        },
        "number": {
          "hint": "Введите номер телефона",
          "get": "Получить код",
          "header": "Восстановление пароля",
          "msg":
              "Введите свой номер телефона, и на него поступит звонок, последние четыре цифры которого и будут являться Вашим проверочным кодом"
        },
        "error": "Что-то пошло не так. Пожалуйста, повторите попытку позднее"
      },
      "conclusion": {
        "header": "Пароль успешно восстановлен",
        "msg":
            "Теперь вы можете использовать новый пароль для защиты своих данных",
        "ok": "Понятно"
      },
      "create": {
        "header": "Восстановление пароля",
        "msg": "Придумайте новый надежный пароль",
        "hint": "Введите пароль",
        "continue": "Продолжить",
        "error": {
          "diff": "Введеные пароли не совпадают",
          "length": "Пароль дожен содержать не менее 8 символов",
          "bad": "Не удалось установить новый пароль"
        }
      },
      "code": {
        "number": "номер телефона",
        "email": "электронную почту",
        "hint": "Введите полученный код",
        "again": "Отправить код повторно",
        "error":
            "Не удалось отправить код проверки. Пожалуйста, проверьте правильность введенных данных и повторите попытку",
        "error_uncorrect":
            "Введен некорректный код. Пожалуйста, проверьте правильность введенных данных и повторите попытку",
        "action": "Восстановить",
        "header": "Восстановление пароля",
        "message": "{} отправлен на {}:\n {}"
      },
      "checkType": {
        "number": "По номеру телефона",
        "email": "По адресу E-mail",
        "header": "Восстановление пароля"
      }
    },
    "appUpdater": {
      "title": "Обновить NikahTime?",
      "description": "Доступна новая версия NikahTime!",
      "remindAction": "Напомнить мне позже",
      "cancelAction": "Не обновлять",
      "updateAction": "Обновить"
    },
    "smoking": "Курение",
    "alcohol": "Алкоголь",
    "gambling": "Игровая зависимость",
    "other_h": "Другое",
    "other": "Другое",
    "missing": "Отсутствуют",
    "needPhotoError": "Необходимо загрузить хотя-бы одну фотографию",
    "news": {
      "header": "Новости",
      "read": "Читать дальше",
      "searchHint": "Введите строку для поиска",
      "loading": {
        "feed": "Подождите, идет загрузка новостей",
        "news": "Подождите, идет загрузка новости",
        "commentaries": "Подождите, идет загрузка комментариев"
      },
      "addComment": "Добавить комментарий",
      "reply": "Ответить",
      "commentReply": "Ответы к комментарию",
      "commentEmpty": "Комментариев пока нет",
      "commentaries": "Комментарии",
      "showAllCommenaries": "Показать все ответы",
      "timeAgo": {
        "now": "Только что",
        "min": "м. назад",
        "hour": "ч. назад",
        "day": "д. назад"
      },
      "views": {"thousand": "тыс.", "million": "млн.", "billion": "млрд."}
    }
  };
  static const Map<String, dynamic> en = {
    "app_locale": "en",
    "usersScreen": {
      "tittle": "Users",
      "loading": "Wait, user profiles are being loaded",
      "notFound": "Unfortunately, no one is here yet",
      "searchNotFound": "Unfortunately, we can't find any user",
      "searchHint": "Input search value here",
      "searchMainHint":
          "To search for users, you must enter the first or last name in the search bar",
      "match": {
        "male": "{firstName} likes you too!\nYou can be the first to write.",
        "female": "{firstName} likes you too!\nYou can be the first to write.",
        "": "{firstName} likes you too!\nYou can be the first to write."
      },
      "writeMessage": "Write a message",
      "continueViewing": "Continue browsing",
      "selectedForYou": "Chosen for you",
      "favorites": "Favorites",
      "youFavorite": "You Favourite",
      "liked": "I liked by"
    },
    "user": {
      "hide": "Hide",
      "more": "More",
      "firstName": "Name",
      "lastName": "Last Name",
      "age": "Age",
      "yearsCount": {
        "zero": "{} y.o.",
        "one": "{} y.o.",
        "two": "{} y.o.",
        "few": "{} y.o.",
        "many": "{} y.o.",
        "other": "{} y.o."
      },
      "gender": {"title": "Gender", "male": "Male", "female": "Female"},
      "interests": "Interests",
      "aboutMe": "About",
      "education": "Education",
      "placeOfStudy": "Place of study",
      "birthDate": "Birth date",
      "country": "Country",
      "city": "City",
      "contactPhoneNumber": "Contact phone number",
      "placeOfWork": "Place of work",
      "workPosition": "Work Position",
      "maritalStatus": "Marital status",
      "faith": "Possibility of moving",
      "canons": "Faith",
      "haveChildren": {
        "title": "Children",
        "hint": "Are there children?",
        "yes": "Yes",
        "no": "No"
      },
      "badHabits": "Bad habits",
      "nationality": "Nationality",
      "photos": "Photos"
    },
    "filters": {
      "tittle": "Filters",
      "complicatedFilterTittle": "Who are you interested in?",
      "reset": "Reset",
      "isOnline": "Online now",
      "simpleFilter": "Simple filter",
      "complicatedFilter": "Advanced filter",
      "close": "Close",
      "from": "From",
      "to": "To",
      "maritalStatusTitle": "Marital status of interest",
      "educationTitle": "Education of interest",
      "find": "Find"
    },
    "profileScreen": {
      "title": "Profile",
      "generalInformation": "Main Info",
      "settings": {
        "header": "Settings",
        "subscription": {
          "header": "Subscription",
          "type": {
            "header": "Type: ",
            "no": "No",
            "unlimited": "Unlimited",
            "trial": "Trial",
            "1_month": "1 month",
            "3_months": "3 months",
            "6_months": "6 months"
          },
          "subscribe": "Subscribe",
          "expires": "Expires: "
        },
        "language": {
          "header": "Application Language",
          "text": "Application in English"
        },
        "common": "General",
        "privacy": "Privacy Policy",
        "agreement": "User Agreement",
        "useTerms": "Application Terms",
        "paymentRules": "Payment Terms",
        "refundRules": "Refund Rules",
        "tariffs": "Tariffs",
        "refund": "Refund Guaranties",
        "help": "Help",
        "error": {
          "header": "Error",
          "text": "Mail client not found. Our mail: nikahtime@bk.ru"
        },
        "mail": "Our mail: nikahtime@bk.ru\n",
        "connectToDevs": "Message to developers",
        "deleteAccount": "Delete account",
        "deleteAccountAlert": {
          "cancel": "Cancel",
          "header": "Delete an account?",
          "confirm": "Delete",
          "msg": "All account data will be deleted."
        },
        "exit": "Exit",
        "about": "About us",
        "directors":
            "Director of the Center for Family Creation and Preservation NikahTime",
        "associateDirectors": "Assistant Director of Public Relations",
        "psychologists": "Psychologists",
        "hazrats": "Hazrats",
        "curators": "Curator of NikahTime",
        "psychologist_single": "Psychologist",
        "shariaJudge": "Sharia judge",
        "link": "Open in VK",
        "link_second": "Open in WhatsApp",
        "price": "The cost of a consultation lasting up to 60 minutes",
        "donate_msg_text":
            "Assalamu Alaikum wa Rahmatullahi wa Barakatuh and greetings of the day, dear user! The goal of the NikahTime app is that, by the grace of Allah, everyone who wishes can find happiness and their other half! You have the opportunity to participate in this noble cause and help NikahTime improve by making a Sadaqah (donation) to the card number 2202 2032 5291 7218. We are raising these funds to develop and release a new version of NikahTime!",
        "text_copied": "Card number copied",
        "phone_copied": "Phone number copied",
        "donate_msg": {
          "header": "Support the Project",
          "text":
              "Dear user, if you make a Sadaqah (donation), these funds will go toward making the world a kinder place! It will also support the growth and maintenance of the NikahTime project!",
          "text2":
              "Thank you! You are helping us make the world a better place!",
          "later_btn": "Later",
          "support_btn": "Support"
        },
        "theme": {
          "header": "Theme",
          "tiffani": "Tiffany",
          "pinkClouds": "Pink Clouds"
        },
        "notifications": "Notifications",
        "family_consultation": "Family Consultation",
        "change_photo": "Change Photo"
      }
    },
    "paymentScreen": {
      "tittle": "Subscriptions",
      "promo": "SPECIAL",
      "paymentButton": "Subscribe",
      "paymentDone": "Subscription is issued",
      "daysCount": {
        "zero": "{} days",
        "one": "{} day",
        "many": "{} days",
        "other": "{} days"
      },
      "monthsCount": {
        "zero": "{} mos",
        "one": "{} mo",
        "many": "{} mos",
        "other": "{} mos"
      },
      "tariffDescription": "Extended app features for",
      "feature1": "Unlimited number of user profiles available for viewing",
      "feature2": "The ability to express sympathy to people you like",
      "feature3": "The ability to communicate inside the app",
      "feature4": "View mutual likes and visitors of your profile",
      "continue": "Continue",
      "paymentMethod": "Payment method",
      "paymentMethodCard": "Card",
      "emailForReceiptTitle": "Email for receipt",
      "emailForReceiptError": {
        "emailRequired": "You need to specify the email for the receipt",
        "emailInvalid": "E-mail is not specified correctly"
      },
      "error": {
        "title": "Error",
        "closeButton": "Close",
        "unknown":
            "Sorry, the purchase is unavailable for an unknown reason. Please try again later.",
        "clientInvalid":
            "The purchase cannot be made, try changing your account or device.",
        "paymentCancelled": "You canceled the purchase.",
        "paymentInvalid":
            "The purchase was rejected. Please check the payment details and make sure that there are enough funds in the account.",
        "paymentNotAllowed":
            "The purchase is not available for the selected payment method. Please make sure that your payment method allows you to pay for purchases online.",
        "storeProductNotAvailable":
            "This product is not available in your region. Please change the store and try again.",
        "cloudServicePermissionDenied": "The purchase was rejected.",
        "cloudServiceNetworkConnectionFailed":
            "The purchase cannot be made because the device is offline. Please try again with a stable internet connection.",
        "cloudServiceRevoked": "The purchase was rejected.",
        "privacyAcknowledgementRequired":
            "The purchase cannot be made because you have not agreed to the AppStore terms of use. Please confirm your consent in the settings and return to the purchase.",
        "unauthorizedRequestData":
            "An error has occurred. Please come back to purchase later.",
        "invalidOfferIdentifier": "The promo offer is invalid.",
        "invalidSignature":
            "Sorry, there was an error when using the promo code. Please try again later.",
        "missingOfferParams":
            "Sorry, there was an error when using the promo offer. Please try again later.",
        "invalidOfferPrice":
            "Sorry, the purchase is not possible. Try to repeat it later.",
        "verifyError":
            "Sorry, there was a purchase error. The funds will be refunded after 3 days if the subscription is not activated.",
        "verifyAppStoreError":
            "Sorry, there was a purchase error. The funds will be refunded after 3 days if the subscription is not activated.",
        "duplicateProductObject":
            "Subscription activation is in processing. The funds will be refunded after 3 days if the subscription is not activated."
      }
    },
    "tariffs": {
      "description":
          "One of the main goals of the NikahTime app is to speed up the process of finding a soulmate, helping as many people as possible to get married.",
      "header": "Premium Subscription Features:",
      "option1":
          "Display the number of times stories are viewed by the same person",
      "option2": "Show the time of story views",
      "option3": "Anonymous story viewing",
      "option4": "Anonymous reading of messages",
      "option5": "View the last seen time of users",
      "option6": "Ability to post stories",
      "option7": "Customizable incognito mode for visiting profiles",
      "button": "Subscribe for 169 RUB/month",
      "canCancel": "You can cancel at any time",
      "alertTitle": "Great news! You already have access to premium features.",
      "alertContent":
          "This promotion is valid for one month only. You are already using the premium features of our app. Thank you for staying with us!"
    },
    "common": {
      "online": "Online",
      "offline": "Offline",
      "videoWaitBox": "Please wait, video are being loaded",
      "apply": "Apply",
      "takePhoto": "Take photo from Camera",
      "getPhoto": "Take photo from Gallery",
      "takeVide": "Take video from Camera",
      "getVideo": "Take video from Gallery",
      "delete": "Delete",
      "errorHintText": "This field is required",
      "phoneNumberHint": "Input country name or code",
      "selectOptions": "Select options",
      "confirm": "Confirm",
      "cancel": "Cancel",
      "change": "Change",
      "notSet": "Not Set",
      "setCountry": "Choose country",
      "setMaritalStatus": "Choose marital status",
      "setCountryAndCode": "Input country name or dial code",
      "chooseOptions": "Choose options",
      "vizited_q": "Who vizited me?",
      "vizited": "Vizited me",
      "usingPhoneNumberHint": "The phone number will be visible only to you",
      "payment": {
        "alert": {
          "titleForView": "More features with a subscription",
          "titleForAction": "More features with a subscription",
          "detail":
              "Only now subscription for the price of a cup of coffee ☕️\nDon't miss the opportunity to find your soulmate!",
          "moreButton": "More",
          "notNowButton": "Not now"
        }
      },
      "fieldNotRequired": "(not required)"
    },
    "educationList": {
      "basicGeneral": "Basic General",
      "secondaryGeneral": "Secondary General",
      "secondaryVocational": "Vocational education",
      "higherBachelorOrSpecialist": "Higher (bachelor or specialist)",
      "higherMaster": "Higher (magistr)",
      "academicDegree": "Doctor"
    },
    "nationalityState": {"notSelected": "Not selected"},
    "familyState": {
      "notMarried": "Single",
      "married": "Married",
      "divorced": "Divorced"
    },
    "observantOfTheCanonsFemaleState": {
      "observingIslamCanons": "Islamic Muslim woman",
      "nonObservingIslamCanons": "I observe religious rites \non holidays"
    },
    "observantOfTheCanonsMaleState": {
      "observingIslamCanons": "Islamic Muslim man",
      "nonObservingIslamCanons": "I observe religious rites \non holidays"
    },
    "islam": "Islam",
    "christianity": "Christianity",
    "judaism": "Judaism",
    "another": "Another",
    "any":"Any",
    "religionSubtitle": "Religious  affiliation",
    "contacts": "Contacts",
    "contact": {
      "not_registered": "There are no registered contacts",
      "access_denied": "Access is denied",
      "error": "An error has occurred"
    },
    "faithState": {
      "observantMuslim": "Ready to move",
      "nonObservantMuslim": "Not ready to move",
      "notSelected": "Not selected"
    },
    "childrenState": {"yes": "Have children", "no": "No children"},
    "badHabbits": {
      "smoking": "Smoking",
      "alcohol": "Alcohol",
      "gambling": "Gambling addiction",
      "other_h": "Other",
      "missing": "Missing"
    },
    "interestTag": {
      "walks": "Walks",
      "sport": "Sport",
      "cinema": "Cinema",
      "yoga": "Yoga",
      "food": "Food",
      "tourism": "Tourism",
      "leisure": "Leisure",
      "swimming": "Swimming",
      "crossFit": "CrossFit",
      "bicycle": "Bicycle",
      "animals": "Animals",
      "comedy": "Comedy",
      "love": "Love"
    },
    "claim": {
      "toReport": "Report",
      "claimReason": {
        "propaganda": "Hate propaganda and inciting hatred",
        "misleading": "Misleading",
        "promo": "Promotional materials",
        "bulling": "Offensive language",
        "adults": "Adult content",
        "spam": "Spam",
        "finance": "Financial services"
      },
      "description":
          "We will review this report within 24 hours and, if a violation is detected, we will take the necessary measures to stop it.",
      "send": "Send",
      "reason": "Select a reason for the complaint",
      "comment": "Comment"
    },
    "chat": {
      "cancelButtonText": "OK",
      "attentionHeader": "Attention",
      "attentionText": "Your profile is blocked.",
      "waitbox": "Wait, chat is loading",
      "main": {
        "header": "Chats",
        "find": "Chat search",
        "you": "you: ",
        "min": "min.",
        "hour": "h.",
        "day": "d.",
        "now": "now",
        "lastTimeOnline": {"prefix": "Was online ", "postfix": " ago"}
      },
      "del": {
        "cancel": "Cancel",
        "header": "Attention",
        "confirm": "Confirm",
        "alert": "Attention",
        "msg": "Are you sure you want to delete the selected chat"
      },
      "file": "File",
      "img": "Image",
      "video": "Video",
      "bottom": {
        "img": {
          "take": "Take a photo with the camera",
          "get": "Select photo from gallery"
        },
        "video": {
          "take": "Record video on camera",
          "get": "Select video from gallery"
        },
        "file": "Select file from storage"
      },
      "blocked": "Sending messages is limited",
      "fileWaitBox": "Attachment is loading",
      "block": "Block",
      "unblock": "Unblock",
      "delete": "Delete dialog",
      "report": "Report"
    },
    "welcome_screen": {
      "createAcc": "Create account",
      "ageConfirmed": {
        "question": "Are you 18?",
        "bad": "I'm not 18 yet",
        "good": "I'm 18",
        "action": "Verify Your age to continue"
      },
      "alreadyLogged": "Already logged in? ",
      "authorize": "Sign In",
      "carousel": {
        "item1": {
          "header": "Handy filters",
          "text": "Customize your filters and\nfind only those you like"
        },
        "item2": {
          "header": "People only",
          "text": "Our app does a thorough\ncheck without missing any bots"
        },
        "item3": {
          "header": "Chat",
          "text":
              "Communicate in a convenient and simple chat\nwith the people you like"
        }
      }
    },
    "registration": {
      "header": "Registration",
      "appendix": {
        "text": "By registering You agree with\n",
        "item1": "Privacy Policy",
        "and": " and ",
        "item2": "Terms of Use"
      },
      "sendCode": "Send Code",
      "type": {
        "message": "or register by",
        "phone": {
          "by": "Phone number",
          "header": "My number",
          "text":
              "Please enter your current phone number. We will send you a 6-digit code to verify your account. ",
          "hintPass": "Create password",
          "hintSecPass": "Repeat password",
          "error":
              "A user with this phone number already exists. If it's you, go through the password recovery procedure",
          "nextScreenMessage": "specified number"
        },
        "email": {
          "by": "E-mail address",
          "header": "My E-mail",
          "text":
              "Please enter your current E-mail address. We will send you a 6-digit code to verify your account. ",
          "hintMail": "Enter E-mail",
          "hintPass": "Create password",
          "hintSecPass": "Repeat password",
          "error":
              "A user with this E-mail address already exists. If it's you, go through the password recovery procedure",
          "nextScreenMessage": "specified E-mail address"
        }
      },
      "PIN": {
        "header": "PIN",
        "action": "Continue",
        "message": "PIN-code was send to {}:\n {}",
        "sendAgain": "Send PIN-code again"
      },
      "error": {
        "msg": "Check your input and try again",
        "diffPass": "The entered passwords do not match.",
        "badPass": "Password must be at least 8 characters long",
        "badPIN": "Incorrect code entered",
        "maxLength": "Reached max length (less 25 symbols)"
      },
      "profile": {
        "header": "Profile Creation",
        "educationHint": "Select your education"
      },
      "interest": {
        "header": "Your interests",
        "subheader":
            "Please add at least 5 interests so we can find more suitable people",
        "addNew": "Add your own"
      },
      "about": {
        "header": "About me",
        "subheader":
            "Write some information about yourself. This way more people will write to you.",
        "example":
            "For example: I have a university degree, I walk my dog in the morning, I go to the movies in my spare time."
      }
    },
    "entering": {
      "error": {
        "dataType":
            "Check that the entered data is correct and try again\nNumber example: +79998887766 or 79998887766\nEmail address example: address@mailbox.domain",
        "nouser":
            "The requested user does not exist or the password is incorrect. Please check that the entered data is correct and try again.",
        "badEmail":
            "Incorrect email address entered. Check your input and try again.\nExample of a valid email address: xxx@xxx.xx",
        "badNumber":
            "Invalid phone number entered. Please check your input and try again.\nExample of a valid phone number: +79998887766 or 79998887766"
      },
      "main": {
        "header": "Entering",
        "divider": "or sign in with",
        "hintData": "Enter Email or phone number",
        "hintPass": "Enter password",
        "hintRecPass": "Forgot your password?",
        "enter": "Enter"
      },
      "recoveryBy": {
        "email": {
          "hint": "Enter Email",
          "get": "Get code",
          "header": "Password recovery",
          "msg":
              "Enter your Email and you will receive an email with a code to reset your password"
        },
        "number": {
          "hint": "Enter phone number",
          "get": "Get code",
          "header": "Password recovery",
          "msg":
              "Enter your phone number, and it will receive a call, the last four digits of which will be your verification code."
        },
        "error": "Something went wrong, please try again later"
      },
      "conclusion": {
        "header": "Password recovered successfully",
        "msg": "You can now use your new password to protect your data",
        "ok": "Got it"
      },
      "create": {
        "header": "Password recovery",
        "msg": "Create a new strong password",
        "hint": "Enter password",
        "continue": "Continue",
        "error": {
          "diff": "The entered passwords do not match",
          "length": "Password must be at least 8 characters",
          "bad": "Unable to set new password"
        }
      },
      "code": {
        "number": "phone number",
        "email": "email",
        "hint": "Enter received code",
        "again": "Resend code",
        "error":
            "Failed to send the verification code. Please check the correctness of the entered data and try again",
        "error_uncorrect":
            "Incorrect code entered. Please check the correctness of the entered data and try again",
        "action": "Restore",
        "header": "Password recovery",
        "message": "Code sent to {}:\n {}"
      },
      "checkType": {
        "number": "By phone number",
        "email": "By E-mail address",
        "header": "Password recovery"
      }
    },
    "appUpdater": {
      "title": "Update NikahTime?",
      "description": "A new version of NikahTime is available!",
      "remindAction": "Remind me later",
      "cancelAction": "Not update",
      "updateAction": "Update"
    },
    "smoking": "Smoking",
    "alcohol": "Alcohol",
    "gambling": "Gambling addiction",
    "other": "other",
    "other_h": "Other",
    "missing": "Missing",
    "needPhotoError": "You must add at least 1 photo",
    "news": {
      "header": "News",
      "read": "Continue reading",
      "searchHint": "Enter a search string",
      "loading": {
        "feed": "Please wait, loading news",
        "news": "Please wait, news is loading",
        "commentaries": "Please wait, comments are loading"
      },
      "addComment": "Add comment",
      "reply": "Reply",
      "commentReply": "Comment replies",
      "commentEmpty": "No comments yet",
      "commentaries": "Commentaries",
      "showAllCommenaries": "Show all replies",
      "timeAgo": {
        "now": "Just yet",
        "min": "m. back",
        "hour": "h. ago",
        "day": "d. ago"
      },
      "views": {"thousand": "K", "million": "M", "billion": "B"}
    }
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ru": ru,
    "en": en
  };
}
