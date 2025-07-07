# Про цю книгу

## Ліцензія

Книга «Little Redis Book» (Маленька книжка про Редіс) ліцензована за ліцензією Attribution-NonCommercial 3.0 Unported. Ви не повинні платити за цю книгу.

Ви можете вільно копіювати, розповсюджувати, змінювати або демонструвати цю книгу. Однак я прошу вас завжди вказувати мене, Карла Сеґуіна (Karl Seguin), як автора книги та не використовувати її в комерційних цілях.

You can see the *full text* of **the license at**:

<http://creativecommons.org/licenses/by-nc/3.0/legalcode>

## Про автора

Карл Сеґуін (Karl Seguin) — розробник з досвідом роботи в різних галузях та технологіях. Він є активним учасником проектів з відкритим кодом, технічним письменником та періодичним доповідачем. Він написав низку статей, а також кілька інструментів про Redis. Redis забезпечує ранжування та статистику його безкоштовного сервісу для розробників казуальних ігор: [mogade.com](http://mogade.com/).

Карл написав [The Little MongoDB Book](http://openmymind.net/2011/3/28/The-Little-MongoDB-Book/), безкоштовну і популярну книгу про MongoDB.

Його блог можна знайти за адресою <http://openmymind.net>, а твіти — за посиланням [@karlseguin](http://twitter.com/karlseguin).

## З вдячністю за підтримку

Особлива подяка [Перрі Нілу](https://twitter.com/perryneal) за те, що поділився зі мною своїми очима, розумом і пристрастю. Ви надали мені неоціненну допомогу. Дякую.

## Актуальна версія

Актуальна версія цієї книги (мовою оригіналу) доступна за адресою:
<http://github.com/karlseguin/the-little-redis-book>

# Вступ

За останні кілька років технології та інструменти, що використовуються для збереження та пошуку даних, розвивалися неймовірними темпами. Хоча можна з упевненістю сказати, що реляційні бази даних не збираються нікуди зникати, можна також стверджувати, що екосистема навколо даних ніколи не буде такою, як раніше.

З усіх нових інструментів та рішень для мене найцікавішим є Redis. Чому? По-перше, тому що його неймовірно легко освоїти. Години — це правильна одиниця виміру, коли йдеться про час, необхідний для того, щоб засвоїти Redis. По-друге, він вирішує конкретний набір проблем, водночас залишаючись досить універсальним. Що це означає? Redis не намагається бути універсальним для всіх даних. Коли ви знайомитеся з Redis, ставатиме все очевиднішим, що в ньому можна, а що ні. І коли це відбувається, для розробника це чудовий досвід.

Хоча ви можете побудувати повну систему, використовуючи тільки Redis, я думаю, що більшість людей вважатимуть, що він доповнює їх більш загальне рішення для даних — будь то традиційна реляційна база даних, система, орієнтована на документи, або щось інше. Це рішення, яке ви використовуєте для реалізації конкретних функцій. У цьому сенсі воно схоже на механізм індексації. Ви не будете будувати всю свою програму на Lucene. Але коли вам потрібний хороший пошук, це набагато кращий досвід — як для вас, так і для ваших користувачів. Звичайно, на цьому схожість між Redis та індексувальними двигунами закінчується.

Мета цієї книги — закласти основи, необхідні для оволодіння Redis. Ми зосередимося на вивченні п'яти структур даних Redis і розглянемо різні підходи до моделювання даних. Ми також торкнемося деяких ключових адміністративних деталей і технік налагодження.

# Початок роботи

Всі ми вчимося по-різному: комусь подобається бруднити руки, хтось дивитися відео, а хтось воліє читати. Ніщо не допоможе вам зрозуміти Redis краще, ніж власний досвід. Redis легко встановити, і він має просту оболонку, яка надасть нам усе необхідне. Приділімо кілька хвилин, щоб запустити його на нашому комп'ютері.

## На Windows

Redis офіційно не підтримує Windows, але є доступні варіанти. Ви не будете використовувати їх у виробничому середовищі, але я ніколи не стикався з жодними обмеженнями під час розробки.

Портовану версію з підтримкою Windows від Microsoft Open Technologies, Inc. можна знайти за адресою <https://github.com/MSOpenTech/redis>. На момент написання цієї статті рішення не готове для використання у виробничих системах.

Інше рішення, яке доступне вже деякий час, можна знайти за адресою <https://github.com/dmajkic/redis/downloads>. Ви можете завантажити найновішу версію (яка повинна бути першою в списку). Розпакуйте zip-файл і, залежно від архітектури вашої системи, відкрийте папку `64bit` або `32bit`.

## На *nix and MacOSX

Для користувачів *nix та MacOSX найкращим варіантом є компіляція з вихідного коду. Інструкції, а також номер останньої версії, доступні за адресою <http://redis.io/download>. На момент написання цієї статті останньою версією є 3.0.3; для встановлення цієї версії потрібно виконати:

```
wget http://download.redis.io/releases/redis-3.0.3.tar.gz
tar xzf redis-3.0.3.tar.gz
cd redis-3.0.3
make
```

(Крім того, Redis доступний через різні менеджери пакетів. Наприклад, користувачі MacOSX з встановленим Homebrew можуть просто ввести `brew install redis`.)

Якщо ви зібрали програму з вихідного коду, бінарні файли знаходяться в каталозі `src`. Перейдіть до каталогу `src`, виконавши команду `cd src`.

## Запуск і підключення до Redis

Якщо все працює, бінарні файли Redis повинні бути доступні. Redis має кілька виконуваних файлів. Ми зосередимося на сервері Redis і командному інтерфейсі Redis (клієнт, схожий на DOS). Запустимо сервер. У Windows двічі клацніть на `redis-server`. У *nix/MacOSX запустіть `./redis-server`.

Якщо ви прочитаєте повідомлення про запуск, то побачите попередження про те, що файл `redis.conf` не вдалося знайти. Redis замість цього використовуватиме вбудовані значення за замовчуванням, що цілком підійде для наших потреб.

Далі запустіть консоль Redis, двічі клацнувши на `redis-cli` (Windows) або виконавши `./redis-cli` (*nix/MacOSX). Це підключить вас до локального сервера, що працює на стандартному порту (6379).

Ви можете перевірити, чи все працює, ввівши `info` в інтерфейс командного рядка. Сподіваємося, ви побачите низку пар ключ-значення, які надають багато інформації про стан сервера.

Якщо у вас виникли проблеми з налаштуванням, описаним вище, рекомендую звернутися за допомогою до [офіційної групи підтримки Redis](https://groups.google.com/forum/#!forum/redis-db).

# Драйвери Redis

Як ви скоро дізнаєтеся, API Redis найкраще описати як явний набір функцій. Він має дуже простий і процедурний вигляд. Це означає, що незалежно від того, чи використовуєте ви інструмент командного рядка, чи драйвер для вашої улюбленої мови програмування, все буде дуже схоже. Тому, якщо ви віддаєте перевагу роботі з мовою програмування, у вас не повинно виникнути жодних проблем. Якщо бажаєте, перейдіть на [сторінку клієнта](http://redis.io/clients) і завантажте відповідний драйвер.

# Розділ 1 - Основи

Чим особливий Redis? Які типи проблем він вирішує? На що слід звернути увагу розробникам під час його використання? Перш ніж відповісти на ці питання, потрібно зрозуміти, що таке Redis.

Redis часто описують як постійне сховище ключів-значень в оперативній пам'яті. Я не вважаю це точним описом. Redis дійсно зберігає всі дані в оперативній пам'яті (про це детальніше трохи пізніше) і записує їх на диск для збереження, але це набагато більше, ніж просте сховище ключів-значень. Важливо нівелювати це хибне уявлення, інакше ваше розуміння Redis і проблем, які він вирішує, буде занадто вузьким.

Насправді Redis надає п'ять різних структур даних, лише одна з яких є типовою структурою ключ-значення. Розуміння цих п'яти структур даних, їхнього функціонування, методів, які вони надають, та того, що ви можете моделювати за їх допомогою, є ключем до розуміння Redis. Але спочатку давайте розберемося, що означає надавати структури даних.

Якщо застосувати це поняття структури даних до реляційного світу, можна сказати, що бази даних надають доступ до єдиної структури даних — таблиць. Таблиці є одночасно складними і гнучкими. За допомогою таблиць можна моделювати, зберігати і обробляти майже все. Однак їх універсальний характер має і свої недоліки. Зокрема, не все є настільки простим і швидким, як хотілося б. А що, якби замість універсальної структури ми використовували більш спеціалізовані структури? Можливо, деякі речі ми не зможемо зробити (або, принаймні, не зможемо зробити дуже добре), але натомість ми точно виграємо в простоті та швидкості?

Використовувати конкретні структури даних для конкретних проблем? Хіба не так ми пишемо код? Ви ж не використовуєте хеш-таблицю для кожного елемента даних, як і не використовуєте скалярну змінну. На мій погляд, це визначає підхід Redis. Якщо ви маєте справу зі скалярними величинами, списками, хешами або наборами, чому б не зберігати їх як скалярні величини, списки, хеші та набори? Чому перевірка наявності значення має бути складнішою, ніж виклик `exists(key)`, або повільнішою, ніж O(1) (постійний час пошуку, який не сповільнюється незалежно від кількості елементів)?

# Будівельні блоки

## Бази даних

Redis має ту саму базову концепцію бази даних, з якою ви вже знайомі. База даних містить набір даних. Типовим випадком використання бази даних є групування всіх даних програми та їх відокремлення від даних іншої програми.

У Redis бази даних просто ідентифікуються за номером, причому база даних за замовчуванням має номер `0`. Якщо ви хочете перейти до іншої бази даних, ви можете зробити це за допомогою команди `select`. У командному рядку введіть `select 1`. Redis повинен відповісти повідомленням `OK`, а ваш підказка повинна змінитися на щось на зразок `redis 127.0.0.1:6379[1]>`. Якщо ви хочете повернутися до бази даних за замовчуванням, просто введіть `select 0` в командному рядку.

## Команди, ключі та значення

Хоча Redis — це більше, ніж просто сховище ключів-значень, в основі кожної з п'яти структур даних Redis лежить принаймні один ключ і одне значення. Перед тим, як перейти до інших доступних елементів інформації, необхідно обов'язково зрозуміти, що таке ключі та значення.

Ключі використовуються для ідентифікації фрагментів даних. Ми будемо часто мати справу з ключами, але поки що достатньо знати, що ключ може виглядати так: `users:leto`. Можна розумно припустити, що такий ключ містить інформацію про користувача з іменем `leto`. Двокрапка не має особливого значення для Redis, але використання роздільника є поширеним підходом, який люди використовують для організації своїх ключів.

Значення представляють фактичні дані, пов'язані з ключем. Вони можуть бути будь-якими. Іноді ви будете зберігати рядки, іноді цілі числа, іноді серіалізовані об'єкти (у форматі JSON, XML або іншому). Здебільшого Redis обробляє значення як масив байтів і не звертає уваги на їхній тип. Зверніть увагу, що різні драйвери по-різному обробляють серіалізацію (деякі залишають це на ваш розсуд), тому в цій книзі ми будемо говорити тільки про рядки, цілі числа та JSON.

Давайте трохи забруднимо руки. Введіть наступну команду:

```
set users:leto '{"name": "leto", "planet": "dune", "likes": ["spice"]}'
```

Це основна структура команди Redis. Спочатку ми маємо саму команду, в даному випадку `set`. Далі йдуть її параметри. Команда `set` приймає два параметри: ключ, який ми встановлюємо, та значення для нього. Багато команд, але не всі, приймають ключ (і коли приймають, то часто це перший параметр). Чи можете ви вгадати, як отримати це значення? Сподіваємося, ви відповіли (але не хвилюйтеся, якщо не були впевнені!):

```
get users:leto
```

Спробуйте погратися з іншими комбінаціями. Ключі та значення є основними поняттями, а команди `get` та `set` — найпростіший спосіб погратися з ними. Створіть більше користувачів, спробуйте різні типи ключів, спробуйте різні значення.

## Запити

У міру того як ви поступово ознайомлюватиметеся з Redis, вам все більше стануть зрозумілими дві речі, що стосуватимуться Redis: ключі — це все, а значення — ніщо. Іншими словами, Redis не дозволяє запитувати значення об'єкта. З огляду на вищесказане, ми не можемо знайти користувачів, які живуть на планеті `dune`.

В багатьох це може викликати певне занепокоєння. Ми живемо у світі, де запити до даних є настільки гнучкими та потужними, що підхід Redis може здатися примітивним і непрактичним. Нехай це вас надто не турбує. Пам'ятайте, Redis — це не універсальне рішення. Будуть речі, які просто не підходять для нього (через обмеження запитів). Також врахуйте, що в деяких випадках ви знайдете нові способи моделювання даних.

Ми розглянемо більш конкретні приклади далі, але важливо зрозуміти цю основну особливість Redis. Це допоможе нам зрозуміти, чому значення можуть бути будь-якими — Redis ніколи не потрібно їх читати чи розуміти. Також це допоможе нам почати думати про моделювання в цьому новому світі.

## Памʼять та Персистентність

Ми вже згадували, що Redis є постійним сховищем, зберігаючи все в оперативній пам'яті. За замовчуванням, задля підтримки персистенності, Redis створює знімки бази даних на диск на основі кількості змінених ключів. Ви можете налаштувати систему так, щоб при зміні X ключів база даних зберігалася кожні Y секунд. За замовчуванням Redis зберігає базу даних кожні 60 секунд, якщо змінилося 1000 або більше ключів, і кожні 15 хвилин, якщо змінилося 9 або менше ключів.

Як альтернатива (як додаток до створення знімків), Redis може працювати в інкрементальному режимі (режимі дозапису). Кожного разу, коли ключ змінюється, на диску оновлюється файл, що доступний тільки в режимі дозапису. У деяких випадках прийнятно втратити дані за 60 секунд в обмін на продуктивність, якщо трапиться збій апаратного або програмного забезпечення. У деяких випадках така втрата є неприйнятною. Redis надає вам можливість вибору. У розділі 6 ми розглянемо третій варіант, який полягає у вивантаженні персистентності на ведений сервер.

Що стосується пам'яті, Redis зберігає всі ваші дані в оперативній пам'яті. Очевидним наслідком цього є вартість експлуатації Redis: оперативна пам'ять залишається найдорожчою операційною частиною серверного обладнання.

Я дійсно вважаю, що деякі розробники втратили уявлення про те, як мало місця можуть займати дані. Повне зібрання творів Вільяма Шекспіра займає приблизно 5,5 МБ пам'яті. Що стосується масштабування, інші рішення, як правило, обмежені пропускною здатністю вводу-виводу або процесора. Яке обмеження (оперативна пам'ять або пропускна здатність вводу-виводу) вимагатиме масштабування на більшу кількість машин, насправді залежить від типу даних і того, як ви їх зберігаєте та запитуєте. Якщо ви не зберігаєте великі мультимедійні файли в Redis, обсяг оперативної пам'яті, ймовірно, не буде проблемою. Для додатків, де це є проблемою, вам, ймовірно, доведеться поступитися пропускною здатністю вводу-виводу на користь обсягу оперативної пам'яті.

Redis дійсно додав підтримку віртуальної пам'яті. Однак ця функція була визнана невдалою (самими розробниками Redis) і її використання було припинено.

(До речі, файл з повним зібранням творів Шекспіра розміром 5,5 МБ можна стиснути приблизно до 2 МБ. Redis не виконує автоматичне стиснення, але, оскільки він обробляє значення як байти, немає причин, чому б не обміняти час обробки на оперативну пам'ять, стискаючи/розпаковуючи дані самостійно.)

## Збираємо все до купи

Ми торкнулися низки важливих тем. Перед тим, як заглибитися в Redis, я хотів би об'єднати деякі з них. Зокрема, обмеження запитів, структури даних та спосіб зберігання даних у пам'яті Redis.

Якщо обʼєднати ці три речі разом, ви отримаєте щось дивовижне: швидкість. Деякі люди думають: «Звичайно, Redis швидкий, адже все знаходиться в пам'яті». Але це лише частина правди. Справжня причина, чому Redis вигідно відрізняється від інших рішень, — це його спеціалізовані структури даних.

Як швидко? Це залежить від багатьох факторів — від того, які команди ви використовуєте, від типу даних тощо. Але продуктивність Redis зазвичай вимірюється в десятках тисяч або сотнях тисяч операцій **за секунду**. Ви можете запустити `redis-benchmark` (який знаходиться в тій самій папці, що й `redis-server` та `redis-cli`), щоб перевірити це самостійно.

Колись, я змінив код який використовував традиційну модель, на Redis. Тест із навантаженням, який я створив, зайняв більше 5 хвилин, щоб завершити використання реляційної моделі. У Redis це зайняло близько 150 мілісекунд. Ви не завжди отримаєте такий величезний виграш, але, сподіваємося, це дасть вам уявлення про те, про що ми говоримо.

Важливо розуміти цей аспект Redis, оскільки він впливає на взаємодію з ним. Розробники з досвідом роботи з SQL часто прагнуть мінімізувати кількість звернень до бази даних. Це хороша порада для будь-якої системи, включаючи Redis. Однак, враховуючи, що ми маємо справу з простішими структурами даних, іноді нам доведеться звертатися до сервера Redis кілька разів, щоб досягти своєї мети. Такі підходи доступу до даних спочатку можуть здаватися неприродними, але насправді це незначні витрати порівняно з продуктивністю, яку ми отримуємо.

## У цьому розділі

Хоча ми ледь встигли попрацювати з Redis, ми охопили широке коло тем. Не хвилюйтеся, якщо щось не зовсім зрозуміло, наприклад, запити. У наступному розділі ми перейдемо до більш практичних завдань, і, сподіваємося, всі ваші запитання знайдуть відповіді.

Основні висновки з цього розділу:

* Ключі — це рядки, які ідентифікують фрагменти даних (значення).

* Значення — це довільні масиви байтів, які Redis не враховує.

* Redis піддтримує реалізацію п'яти спеціалізованих структур даних

* У сукупності вищезазначені особливості роблять Redis швидким і простим у використанні, але не підходять для всіх сценаріїв.

# Chapter 2 - The Data Structures

It's time to look at Redis' five data structures. We'll explain what each data structure is, what methods are available and what type of feature/data you'd use it for.

The only Redis constructs we've seen so far are commands, keys and values. So far, nothing about data structures has been concrete. When we used the `set` command, how did Redis know what data structure to use? It turns out that every command is specific to a data structure. For example when you use `set` you are storing the value in a string data structure. When you use `hset` you are storing it in a hash. Given the small size of Redis' vocabulary, it's quite manageable.

**[Redis' website](http://redis.io/commands) has great reference documentation. There's no point in repeating the work they've already done. We'll only cover the most important commands needed to understand the purpose of a data structure.**

There's nothing more important than having fun and trying things out. You can always erase all the values in your database by entering `flushdb`, so don't be shy and try doing crazy things!

## Strings

Strings are the most basic data structures available in Redis. When you think of a key-value pair, you are thinking of strings. Don't get mixed up by the name, as always, your value can be anything. I prefer to call them "scalars", but maybe that's just me.

We already saw a common use-case for strings, storing instances of objects by key. This is something that you'll make heavy use of:

	set users:leto '{"name": leto, "planet": dune, "likes": ["spice"]}'

Additionally, Redis lets you do some common operations. For example `strlen <key>` can be used to get the length of a key's value; `getrange <key> <start> <end>` returns the specified range of a value; `append <key> <value>` appends the value to the existing value (or creates it if it doesn't exist already). Go ahead and try those out. This is what I get:

	> strlen users:leto
	(integer) 50

	> getrange users:leto 31 48
	"\"likes\": [\"spice\"]"

	> append users:leto " OVER 9000!!"
	(integer) 62

Now, you might be thinking, that's great, but it doesn't make sense. You can't meaningfully pull a range out of JSON or append a value. You are right, the lesson here is that some of the commands, especially with the string data structure, only make sense given specific type of data.

Earlier we learnt that Redis doesn't care about your values. Most of the time that's true. However, a few string commands are specific to some types or structure of values. As a vague example, I could see the above `append` and `getrange` commands being useful in some custom space-efficient serialization. As a more concrete example I give you the `incr`, `incrby`, `decr` and `decrby` commands. These increment or decrement the value of a string:

	> incr stats:page:about
	(integer) 1
	> incr stats:page:about
	(integer) 2

	> incrby ratings:video:12333 5
	(integer) 5
	> incrby ratings:video:12333 3
	(integer) 8

As you can imagine, Redis strings are great for analytics. Try incrementing `users:leto` (a non-integer value) and see what happens (you should get an error).

A more advanced example is the `setbit` and `getbit` commands. There's a [wonderful post](http://blog.getspool.com/2011/11/29/fast-easy-realtime-metrics-using-redis-bitmaps/) on how Spool uses these two commands to efficiently answer the question "how many unique visitors did we have today". For 128 million users a laptop generates the answer in less than 50ms and takes only 16MB of memory.

It isn't important that you understand how bitmaps work, or how Spool uses them, but rather to understand that Redis strings are more powerful than they initially seem. Still, the most common cases are the ones we gave above: storing objects (complex or not) and counters. Also, since getting a value by key is so fast, strings are often used to cache data.

## Hashes

Hashes are a good example of why calling Redis a key-value store isn't quite accurate. You see, in a lot of ways, hashes are like strings. The important difference is that they provide an extra level of indirection: a field. Therefore, the hash equivalents of `set` and `get` are:

	hset users:goku powerlevel 9000
	hget users:goku powerlevel

We can also set multiple fields at once, get multiple fields at once, get all fields and values, list all the fields or delete a specific field:

	hmset users:goku race saiyan age 737
	hmget users:goku race powerlevel
	hgetall users:goku
	hkeys users:goku
	hdel users:goku age

As you can see, hashes give us a bit more control over plain strings. Rather than storing a user as a single serialized value, we could use a hash to get a more accurate representation. The benefit would be the ability to pull and update/delete specific pieces of data, without having to get or write the entire value.

Looking at hashes from the perspective of a well-defined object, such as a user, is key to understanding how they work. And it's true that, for performance reasons, more granular control might be useful. However, in the next chapter we'll look at how hashes can be used to organize your data and make querying more practical. In my opinion, this is where hashes really shine.

## Lists

Lists let you store and manipulate an array of values for a given key. You can add values to the list, get the first or last value and manipulate values at a given index. Lists maintain their order and have efficient index-based operations. We could have a `newusers` list which tracks the newest registered users to our site:

	lpush newusers goku
	ltrim newusers 0 49

First we push a new user at the front of the list, then we trim it so that it only contains the last 50 users. This is a common pattern. `ltrim` is an O(N) operation, where N is the number of values we are removing. In this case, where we always trim after a single insert, it'll actually have a constant performance of O(1) (because N will always be equal to 1).

This is also the first time that we are seeing a value in one key referencing a value in another. If we wanted to get the details of the last 10 users, we'd do the following combination:

	ids = redis.lrange('newusers', 0, 9)
	redis.mget(*ids.map {|u| "users:#{u}"})

The above is a bit of Ruby which shows the type of multiple roundtrips we talked about before.

Of course, lists aren't only good for storing references to other keys. The values can be anything. You could use lists to store logs or track the path a user is taking through a site. If you were building a game, you might use one to track queued user actions.

## Sets

Sets are used to store unique values and provide a number of set-based operations, like unions. Sets aren't ordered but they provide efficient value-based operations. A friend's list is the classic example of using a set:

	sadd friends:leto ghanima paul chani jessica
	sadd friends:duncan paul jessica alia

Regardless of how many friends a user has, we can efficiently tell (O(1)) whether userX is a friend of userY or not:

	sismember friends:leto jessica
	sismember friends:leto vladimir

Furthermore we can see whether two or more people share the same friends:

	sinter friends:leto friends:duncan

and even store the result at a new key:

	sinterstore friends:leto_duncan friends:leto friends:duncan

Sets are great for tagging or tracking any other properties of a value for which duplicates don't make any sense (or where we want to apply set operations such as intersections and unions).

## Sorted Sets

The last and most powerful data structure are sorted sets. If hashes are like strings but with fields, then sorted sets are like sets but with a score. The score provides sorting and ranking capabilities. If we wanted a ranked list of friends, we might do:

	zadd friends:duncan 70 ghanima 95 paul 95 chani 75 jessica 1 vladimir

Want to find out how many friends `duncan` has with a score of 90 or over?

	zcount friends:duncan 90 100

How about figuring out `chani`'s rank?

	zrevrank friends:duncan chani

We use `zrevrank` instead of `zrank` since Redis' default sort is from low to high (but in this case we are ranking from high to low). The most obvious use-case for sorted sets is a leaderboard system. In reality though, anything you want sorted by some integer, and be able to efficiently manipulate based on that score, might be a good fit for a sorted set.

## In This Chapter

That's a high level overview of Redis' five data structures. One of the neat things about Redis is that you can often do more than you first realize. There are probably ways to use string and sorted sets that no one has thought of yet. As long as you understand the normal use-case though, you'll find Redis ideal for all types of problems. Also, just because Redis exposes five data structures and various methods, don't think you need to use all of them. It isn't uncommon to build a feature while only using a handful of commands.

# Chapter 3 - Leveraging Data Structures

In the previous chapter we talked about the five data structures and gave some examples of what problems they might solve. Now it's time to look at a few more advanced, yet common, topics and design patterns.

## Big O Notation

Throughout this book we've made references to the Big O notation in the form of O(n) or O(1). Big O notation is used to explain how something behaves given a certain number of elements. In Redis, it's used to tell us how fast a command is based on the number of items we are dealing with.

Redis documentation tells us the Big O notation for each of its commands. It also tells us what the factors are that influence the performance. Let's look at some examples.

The fastest anything can be is O(1) which is a constant. Whether we are dealing with 5 items or 5 million, you'll get the same performance. The `sismember` command, which tells us if a value belongs to a set, is O(1). `sismember` is a powerful command, and its performance characteristics are a big reason for that. A number of Redis commands are O(1).

Logarithmic, or O(log(N)), is the next fastest possibility because it needs to scan through smaller and smaller partitions. Using this type of divide and conquer approach, a very large number of items quickly gets broken down in a few iterations. `zadd` is a O(log(N)) command, where N is the number of elements already in the sorted set.

Next we have linear commands, or O(N). Looking for a non-indexed column in a table is an O(N) operation. So is using the `ltrim` command. However, in the case of `ltrim`, N isn't the number of elements in the list, but rather the elements being removed. Using `ltrim` to remove 1 item from a list of millions will be faster than using `ltrim` to remove 10 items from a list of thousands. (Though they'll probably both be so fast that you wouldn't be able to time it.)

`zremrangebyscore` which removes elements from a sorted set with a score between a minimum and a maximum value has a complexity of O(log(N)+M). This makes it a mix. By reading the documentation we see that N is the number of total elements in the set and M is the number of elements to be removed. In other words, the number of elements that'll get removed is probably going to be more significant, in terms of performance, than the total number of elements in the set.

The `sort` command, which we'll discuss in greater detail in the next chapter has a complexity of O(N+M*log(M)). From its performance characteristic, you can probably tell that this is one of Redis' most complex commands.

There are a number of other complexities, the two remaining common ones are O(N^2) and O(C^N). The larger N is, the worse these perform relative to a smaller N. None of Redis' commands have this type of complexity.

It's worth pointing out that the Big O notation deals with the worst case. When we say that something takes O(N), we might actually find it right away or it might be the last possible element.


## Pseudo Multi Key Queries

A common situation you'll run into is wanting to query the same value by different keys. For example, you might want to get a user by email (for when they first log in) and also by id (after they've logged in). One horrible solution is to duplicate your user object into two string values:

	set users:leto@dune.gov '{"id": 9001, "email": "leto@dune.gov", ...}'
	set users:9001 '{"id": 9001, "email": "leto@dune.gov", ...}'

This is bad because it's a nightmare to manage and it takes twice the amount of memory.

It would be nice if Redis let you link one key to another, but it doesn't (and it probably never will). A major driver in Redis' development is to keep the code and API clean and simple. The internal implementation of linking keys (there's a lot we can do with keys that we haven't talked about yet) isn't worth it when you consider that Redis already provides a solution: hashes.

Using a hash, we can remove the need for duplication:

	set users:9001 '{"id": 9001, "email": "leto@dune.gov", ...}'
	hset users:lookup:email leto@dune.gov 9001

What we are doing is using the field as a pseudo secondary index and referencing the single user object. To get a user by id, we issue a normal `get`:

	get users:9001

To get a user by email, we issue an `hget` followed by a `get` (in Ruby):

	id = redis.hget('users:lookup:email', 'leto@dune.gov')
	user = redis.get("users:#{id}")

This is something that you'll likely end up doing often. To me, this is where hashes really shine, but it isn't an obvious use-case until you see it.

## References and Indexes

We've seen a couple examples of having one value reference another. We saw it when we looked at our list example, and we saw it in the section above when using hashes to make querying a little easier. What this comes down to is essentially having to manually manage your indexes and references between values. Being honest, I think we can say that's a bit of a downer, especially when you consider having to manage/update/delete these references manually. There is no magic solution to solving this problem in Redis.

We already saw how sets are often used to implement this type of manual index:

	sadd friends:leto ghanima paul chani jessica

Each member of this set is a reference to a Redis string value containing details on the actual user. What if `chani` changes her name, or deletes her account? Maybe it would make sense to also track the inverse relationships:

	sadd friends_of:chani leto paul

Maintenance cost aside, if you are anything like me, you might cringe at the processing and memory cost of having these extra indexed values. In the next section we'll talk about ways to reduce the performance cost of having to do extra round trips (we briefly talked about it in the first chapter).

If you actually think about it though, relational databases have the same overhead. Indexes take memory, must be scanned or ideally seeked and then the corresponding records must be looked up. The overhead is neatly abstracted away (and they  do a lot of optimizations in terms of the processing to make it very efficient).

Again, having to manually deal with references in Redis is unfortunate. But any initial concerns you have about the performance or memory implications of this should be tested. I think you'll find it a non-issue.

## Round Trips and Pipelining

We already mentioned that making frequent trips to the server is a common pattern in Redis. Since it is something you'll do often, it's worth taking a closer look at what features we can leverage to get the most out of it.

First, many commands either accept one or more set of parameters or have a sister-command which takes multiple parameters. We saw `mget` earlier, which takes multiple keys and returns the values:

	ids = redis.lrange('newusers', 0, 9)
	redis.mget(*ids.map {|u| "users:#{u}"})

Or the `sadd` command which adds 1 or more members to a set:

	sadd friends:vladimir piter
	sadd friends:paul jessica leto "leto II" chani

Redis also supports pipelining. Normally when a client sends a request to Redis it waits for the reply before sending the next request. With pipelining you can send a number of requests without waiting for their responses. This reduces the networking overhead and can result in significant performance gains.

It's worth noting that Redis will use memory to queue up the commands, so it's a good idea to batch them. How large a batch you use will depend on what commands you are using, and more specifically, how large the parameters are. But, if you are issuing commands against ~50 character keys, you can probably batch them in thousands or tens of thousands.

Exactly how you execute commands within a pipeline will vary from driver to driver. In Ruby you pass a block to the `pipelined` method:

	redis.pipelined do
	  9001.times do
		redis.incr('powerlevel')
	  end
	end

As you can probably guess, pipelining can really speed up a batch import!

## Transactions

Every Redis command is atomic, including the ones that do multiple things. Additionally, Redis has support for transactions when using multiple commands.

You might not know it, but Redis is actually single-threaded, which is how every command is guaranteed to be atomic. While one command is executing, no other command will run. (We'll briefly talk about scaling in a later chapter.) This is particularly useful when you consider that some commands do multiple things. For example:

`incr` is essentially a `get` followed by a `set`

`getset` sets a new value and returns the original

`setnx` first checks if the key exists, and only sets the value if it does not

Although these commands are useful, you'll inevitably need to run multiple commands as an atomic group. You do so by first issuing the `multi` command, followed by all the commands you want to execute as part of the transaction, and finally executing `exec` to actually execute the commands or `discard` to throw away, and not execute the commands. What guarantee does Redis make about transactions?

* The commands will be executed in order

* The commands will be executed as a single atomic operation (without another client's command being executed halfway through)

* That either all or none of the commands in the transaction will be executed

You can, and should, test this in the command line interface. Also note that there's no reason why you can't combine pipelining and transactions.

	multi
	hincrby groups:1percent balance -9000000000
	hincrby groups:99percent balance 9000000000
	exec

Finally, Redis lets you specify a key (or keys) to watch and conditionally apply a transaction if the key(s) changed. This is used when you need to get values and execute code based on those values, all in a transaction. With the code above, we wouldn't be able to implement our own `incr` command since they are all executed together once `exec` is called. From code, we can't do:

	redis.multi()
	current = redis.get('powerlevel')
	redis.set('powerlevel', current + 1)
	redis.exec()

That isn't how Redis transactions work. But, if we add a `watch` to `powerlevel`, we can do:

	redis.watch('powerlevel')
	current = redis.get('powerlevel')
	redis.multi()
	redis.set('powerlevel', current + 1)
	redis.exec()

If another client changes the value of `powerlevel` after we've called `watch` on it, our transaction will fail. If no client changes the value, the set will work. We can execute this code in a loop until it works.

## Keys Anti-Pattern

In the next chapter we'll talk about commands that aren't specifically related to data structures. Some of these are administrative or debugging tools. But there's one I'd like to talk about in particular: the `keys` command. This command takes a pattern and finds all the matching keys. This command seems like it's well suited for a number of tasks, but it should never be used in production code. Why? Because it does a linear scan through all the keys looking for matches. Or, put simply, it's slow.

How do people try and use it? Say you are building a hosted bug tracking service. Each account will have an `id` and you might decide to store each bug into a string value with a key that looks like `bug:account_id:bug_id`. If you ever need to find all of an account's bugs (to display them, or maybe delete them if they delete their account), you might be tempted (as I was!) to use the `keys` command:

	keys bug:1233:*

The better solution is to use a hash. Much like we can use hashes to provide a way to expose secondary indexes, so too can we use them to organize our data:

	hset bugs:1233 1 '{"id":1, "account": 1233, "subject": "..."}'
	hset bugs:1233 2 '{"id":2, "account": 1233, "subject": "..."}'

To get all the bug ids for an account we simply call `hkeys bugs:1233`. To delete a specific bug we can do `hdel bugs:1233 2` and to delete an account we can delete the key via `del bugs:1233`.


## In This Chapter

This chapter, combined with the previous one, has hopefully given you some insight on how to use Redis to power real features. There are a number of other patterns you can use to build all types of things, but the real key is to understand the fundamental data structures and to get a sense for how they can be used to achieve things beyond your initial perspective.

# Chapter 4 - Beyond The Data Structures

While the five data structures form the foundation of Redis, there are other commands which aren't data structure specific. We've already seen a handful of these: `info`, `select`, `flushdb`, `multi`, `exec`, `discard`, `watch` and `keys`. This chapter will look at some of the other important ones.

## Expiration

Redis allows you to mark a key for expiration. You can give it an absolute time in the form of a Unix timestamp (seconds since January 1, 1970) or a time to live in seconds. This is a key-based command, so it doesn't matter what type of data structure the key represents.

	expire pages:about 30
	expireat pages:about 1356933600

The first command will delete the key (and associated value) after 30 seconds. The second will do the same at 12:00 a.m. December 31st, 2012.

This makes Redis an ideal caching engine. You can find out how long an item has to live until via the `ttl` command and you can remove the expiration on a key via the `persist` command:

	ttl pages:about
	persist pages:about

Finally, there's a special string command, `setex` which lets you set a string and specify a time to live in a single atomic command (this is more for convenience than anything else):

	setex pages:about 30 '<h1>about us</h1>....'

## Publication and Subscriptions

Redis lists have an `blpop` and `brpop` command which returns and removes the first (or last) element from the list or blocks until one is available. These can be used to power a simple queue.

Beyond this, Redis has first-class support for publishing messages and subscribing to channels. You can try this out yourself by opening a second `redis-cli` window. In the first window subscribe to a channel (we'll call it `warnings`):

	subscribe warnings

The reply is the information of your subscription. Now, in the other window, publish a message to the `warnings` channel:

	publish warnings "it's over 9000!"

If you go back to your first window you should have received the message to the `warnings` channel.

You can subscribe to multiple channels (`subscribe channel1 channel2 ...`), subscribe to a pattern of channels (`psubscribe warnings:*`) and use the `unsubscribe` and `punsubscribe` commands to stop listening to one or more channels, or a channel pattern.

Finally, notice that the `publish` command returned the value 1. This indicates the number of clients that received the message.


## Monitor and Slow Log

The `monitor` command lets you see what Redis is up to. It's a great debugging tool that gives you insight into how your application is interacting with Redis. In one of your two redis-cli windows (if one is still subscribed, you can either use the `unsubscribe` command or close the window down and re-open a new one) enter the `monitor` command. In the other, execute any other type of command (like `get` or `set`). You should see those commands, along with their parameters, in the first window.

You should be wary of running monitor in production, it really is a debugging and development tool. Aside from that, there isn't much more to say about it. It's just a really useful tool.

Along with `monitor`, Redis has a `slowlog` which acts as a great profiling tool. It logs any command which takes longer than a specified number of **micro**seconds. In the next section we'll briefly cover how to configure Redis, for now you can configure Redis to log all commands by entering:

	config set slowlog-log-slower-than 0

Next, issue a few commands. Finally you can retrieve all of the logs, or the most recent logs via:

	slowlog get
	slowlog get 10

You can also get the number of items in the slow log by entering `slowlog len`

For each command you entered you should see four parameters:

* An auto-incrementing id

* A Unix timestamp for when the command happened

* The time, in microseconds, it took to run the command

* The command and its parameters

The slow log is maintained in memory, so running it in production, even with a low threshold, shouldn't be a problem. By default it will track the last 1024 logs.

## Sort

One of Redis' most powerful commands is `sort`. It lets you sort the values within a list, set or sorted set (sorted sets are ordered by score, not the members within the set). In its simplest form, it allows us to do:

	rpush users:leto:guesses 5 9 10 2 4 10 19 2
	sort users:leto:guesses

Which will return the values sorted from lowest to highest. Here's a more advanced example:

	sadd friends:ghanima leto paul chani jessica alia duncan
	sort friends:ghanima limit 0 3 desc alpha

The above command shows us how to page the sorted records (via `limit`), how to return the results in descending order (via `desc`) and how to sort lexicographically instead of numerically (via `alpha`).

The real power of `sort` is its ability to sort based on a referenced object. Earlier we showed how lists, sets and sorted sets are often used to reference other Redis objects. The `sort` command can dereference those relations and sort by the underlying value. For example, say we have a bug tracker which lets users watch issues. We might use a set to track the issues being watched:

	sadd watch:leto 12339 1382 338 9338

It might make perfect sense to sort these by id (which the default sort will do), but we'd also like to have these sorted by severity. To do so, we tell Redis what pattern to sort by. First, let's add some more data so we can actually see a meaningful result:

	set severity:12339 3
	set severity:1382 2
	set severity:338 5
	set severity:9338 4

To sort the bugs by severity, from highest to lowest, you'd do:

	sort watch:leto by severity:* desc

Redis will substitute the `*` in our pattern (identified via `by`) with the values in our list/set/sorted set. This will create the key name that Redis will query for the actual values to sort by.

Although you can have millions of keys within Redis, I think the above can get a little messy. Thankfully `sort` can also work on hashes and their fields. Instead of having a bunch of top-level keys you can leverage hashes:

	hset bug:12339 severity 3
	hset bug:12339 priority 1
	hset bug:12339 details '{"id": 12339, ....}'

	hset bug:1382 severity 2
	hset bug:1382 priority 2
	hset bug:1382 details '{"id": 1382, ....}'

	hset bug:338 severity 5
	hset bug:338 priority 3
	hset bug:338 details '{"id": 338, ....}'

	hset bug:9338 severity 4
	hset bug:9338 priority 2
	hset bug:9338 details '{"id": 9338, ....}'

Not only is everything better organized, and we can sort by `severity` or `priority`, but we can also tell `sort` what field to retrieve:

	sort watch:leto by bug:*->priority get bug:*->details

The same value substitution occurs, but Redis also recognizes the `->` sequence and uses it to look into the specified field of our hash. We've also included the `get` parameter, which also does the substitution and field lookup, to retrieve bug details.

Over large sets, `sort` can be slow. The good news is that the output of a `sort` can be stored:

	sort watch:leto by bug:*->priority get bug:*->details store watch_by_priority:leto

Combining the `store` capabilities of `sort` with the expiration commands we've already seen makes for a nice combo.

## Scan

In the previous chapter, we saw how the `keys` command, while useful, shouldn't be used in production. Redis 2.8 introduces the `scan` command which is production-safe. Although `scan` fulfills a similar purpose to `keys` there are a number of important difference. To be honest, most of the *differences* will seem like *idiosyncrasies*, but this is the cost of having a usable command.

First amongst these differences is that a single call to `scan` doesn't necessarily return all matching results. Nothing strange about paged results; however, `scan` returns a variable number of results which cannot be precisely controlled. You can provide a `count` hint, which defaults to 10, but it's entirely possible to get more or less than the specified `count`.

Rather than implementing paging through a `limit` and `offset`, `scan` uses a `cursor`. The first time you call `scan` you supply `0` as the cursor. Below we see an initial call to `scan` with an pattern match (optional) and a count hint (optional):

    scan 0 match bugs:* count 20

As part of its reply, `scan` returns the next cursor to use. Alternatively, scan returns `0` to signify the end of results. Note that the next cursor value doesn't correspond to the result number or anything else which clients might consider useful.

A typical flow might look like this:

    scan 0 match bugs:* count 2
    > 1) "3"
    > 2) 1) "bugs:125"
    scan 3 match bugs:* count 2
    > 1) "0"
    > 2) 1) "bugs:124"
    >    2) "bugs:123"

Our first call returned a next cursor (3) and one result. Our subsequent call, using the next cursor, returned the end cursor (0) and the final two results. The above is a *typical* flow. Since the `count` is merely a hint, it's possible for `scan` to return a next `cursor` (not 0) with no actual results. In other words, an empty result set doesn't signify that no additional results exist. Only a 0 cursor means that there are no additional results.

On the positive side, `scan` is completely stateless from Redis' point of view. So there's no need to close a cursor and there's no harm in not fully reading a result. If you want to, you can stop iterating through results, even if Redis returned a valid next cursor.

There are two other things to keep in mind. First, `scan` can return the same key multiple times. It's up to you to deal with this (likely by keeping a set of already seen values). Secondly, `scan` only guarantees that values which were present during the entire duration of iteration will be returned. If values get added or removed while you're iterating, they may or may not be returned. Again, this comes from `scan`'s statelessness; it doesn't take a snapshot of the existing values (like you'd see with many databases which provide strong consistency guarantees), but rather iterates over the same memory space which may or may not get modified.

In addition to `scan`, `hscan`, `sscan` and `zscan` commands were also added. These let you iterate through hashes, sets and sorted sets. Why are these needed? Well, just like `keys` blocks all other callers, so does the hash command `hgetall` and the set command `smembers`. If you want to iterate over a very large hash or set, you might consider making use of these commands. `zscan` might seem less useful since paging through a sorted set via `zrangebyscore` or `zrangebyrank` is already possible. However, if you want to fully iterate through a large sorted set, `zscan` isn't without value.

## In This Chapter

This chapter focused on non-data structure-specific commands. Like everything else, their use is situational. It isn't uncommon to build an app or feature that won't make use of expiration, publication/subscription and/or sorting. But it's good to know that they are there. Also, we only touched on some of the commands. There are more, and once you've digested the material in this book it's worth going through the [full list](http://redis.io/commands).

# Chapter 5 - Lua Scripting

Redis 2.6 includes a built-in Lua interpreter which developers can leverage to write more advanced queries to be executed within Redis. It wouldn't be wrong of you to think of this capability much like you might view stored procedures available in most relational databases.

The most difficult aspect of mastering this feature is learning Lua. Thankfully, Lua is similar to most general purpose languages, is well documented, has an active community and is useful to know beyond Redis scripting. This chapter won't cover Lua in any detail; but the few examples we look at should hopefully serve as a simple introduction.

## Why?

Before looking at how to use Lua scripting, you might be wondering why you'd want to use it. Many developers dislike traditional stored procedures, is this any different? The short answer is no. Improperly used, Redis' Lua scripting can result in harder to test code, business logic tightly coupled with data access or even duplicated logic.

Properly used however, it's a feature that can simplify code and improve performance. Both of these benefits are largely achieved by grouping multiple commands, along with some simple logic, into a custom-build cohesive function. Code is made simpler because each invocation of a Lua script is run without interruption and thus provides a clean way to create your own atomic commands (essentially eliminating the need to use the cumbersome `watch` command). It can improve performance by removing the need to return intermediary results - the final output can be calculated within the script.

The examples in the following sections will better illustrate these points.

## Eval

The `eval` command takes a Lua script (as a string), the keys we'll be operating against, and an optional set of arbitrary arguments. Let's look at a simple example (executed from Ruby, since running multi-line Redis commands from its command-line tool isn't fun):

    script = <<-eos
      local friend_names = redis.call('smembers', KEYS[1])
      local friends = {}
      for i = 1, #friend_names do
        local friend_key = 'user:' .. friend_names[i]
        local gender = redis.call('hget', friend_key, 'gender')
        if gender == ARGV[1] then
          table.insert(friends, redis.call('hget', friend_key, 'details'))
        end
      end
      return friends
    eos
    Redis.new.eval(script, ['friends:leto'], ['m'])

The above code gets the details for all of Leto's male friends. Notice that to call Redis commands within our script we use the `redis.call("command", ARG1, ARG2, ...)` method.

If you are new to Lua, you should go over each line carefully. It might be useful to know that `{}` creates an empty `table` (which can act as either an array or a dictionary), `#TABLE` gets the number of elements in the TABLE, and `..` is used to concatenate strings.

`eval` actually take 4 parameters. The second parameter should actually be the number of keys; however the Ruby driver automatically creates this for us. Why is this needed? Consider how the above looks like when executed from the CLI:

    eval "....." "friends:leto" "m"
    vs
    eval "....." 1 "friends:leto" "m"

In the first (incorrect) case, how does Redis know which of the parameters are keys and which are simply arbitrary arguments? In the second case, there is no ambiguity.

This brings up a second question: why must keys be explicitly listed? Every command in Redis knows, at execution time, which keys are going to needed. This will allow future tools, like Redis Cluster, to  distribute requests amongst multiple Redis servers. You might have spotted that our above example actually reads from keys dynamically (without having them passed to `eval`). An `hget` is issued on all of Leto's male friends. That's because the need to list keys ahead of time is more of a suggestion than a hard rule. The above code will run fine in a single-instance setup, or even with replication, but won't in the yet-released Redis Cluster.

## Script Management

Even though scripts executed via `eval` are cached by Redis, sending the body every time you want to execute something isn't ideal. Instead, you can register the script with Redis and execute it's key. To do this you use the `script load` command, which returns the SHA1 digest of the script:

    redis = Redis.new
    script_key = redis.script(:load, "THE_SCRIPT")

Once we've loaded the script, we can use `evalsha` to execute it:

    redis.evalsha(script_key, ['friends:leto'], ['m'])

`script kill`, `script flush` and `script exists` are the other commands that you can use to manage Lua scripts. They are used to kill a running script, removing all scripts from the internal cache and seeing if a script already exists within the cache.

## Libraries

Redis' Lua implementation ships with a handful of useful libraries. While `table.lib`, `string.lib` and `math.lib` are quite useful, for me, `cjson.lib` is worth singling out. First, if you find yourself having to pass multiple arguments to a script, it might be cleaner to pass it as JSON:

    redis.evalsha ".....", [KEY1], [JSON.fast_generate({gender: 'm', ghola: true})]

Which you could then deserialize within the Lua script as:

    local arguments = cjson.decode(ARGV[1])

Of course, the JSON library can also be used to parse values stored in Redis itself. Our above example could potentially be rewritten as such:

      local friend_names = redis.call('smembers', KEYS[1])
      local friends = {}
      for i = 1, #friend_names do
        local friend_raw = redis.call('get', 'user:' .. friend_names[i])
        local friend_parsed = cjson.decode(friend_raw)
        if friend_parsed.gender == ARGV[1] then
          table.insert(friends, friend_raw)
        end
      end
      return friends

Instead of getting the gender from specific hash field, we could get it from the stored friend data itself. (This is a much slower solution, and I personally prefer the original, but it does show what's possible).

## Atomic

Since Redis is single-threaded, you don't have to worry about your Lua script being interrupted by another Redis command. One of the most obvious benefits of this is that keys with a TTL won't expire half-way through execution. If a key is present at the start of the script, it'll be present at any point thereafter - unless you delete it.

## Administration

The next chapter will talk about Redis administration and configuration in more detail. For now, simply know that the `lua-time-limit` defines how long a Lua script is allowed to execute before being terminated. The default is generous 5 seconds. Consider lowering it.

## In This Chapter

This chapter introduced Redis' Lua scripting capabilities. Like anything, this feature can be abused. However, used prudently in order to implement your own custom and focused commands, it won't only simplify your code, but will likely improve performance. Lua scripting is like almost every other Redis feature/command: you make limited, if any, use of it at first only to find yourself using it more and more every day.

# Chapter 6 - Administration

Our last chapter is dedicated to some of the administrative aspects of running Redis. In no way is this a comprehensive guide on Redis administration. At best we'll answer some of the more basic questions new users to Redis are most likely to have.

## Configuration

When you first launched the Redis server, it warned you that the `redis.conf` file could not be found. This file can be used to configure various aspects of Redis. A well-documented `redis.conf` file is available for each release of Redis. The sample file contains the default configuration options, so it's useful to both understand what the settings do and what their defaults are. You can find it at <http://download.redis.io/redis-stable/redis.conf>.

Since the file is well-documented, we won't be going over the settings.

In addition to configuring Redis via the `redis.conf` file, the `config set` command can be used to set individual values. In fact, we already used it when setting the `slowlog-log-slower-than` setting to 0.

There's also the `config get` command which displays the value of a setting. This command supports pattern matching. So if we want to display everything related to logging, we can do:

	config get *log*

## Authentication

Redis can be configured to require a password. This is done via the `requirepass` setting (set through either the `redis.conf` file or the `config set` command). When `requirepass` is set to a value (which is the password to use), clients will need to issue an `auth password` command.

Once a client is authenticated, they can issue any command against any database. This includes the `flushall` command which erases every key from every database. Through the configuration, you can rename commands to achieve some security through obfuscation:

	rename-command CONFIG 5ec4db169f9d4dddacbfb0c26ea7e5ef
	rename-command FLUSHALL 1041285018a942a4922cbf76623b741e

Or you can disable a command by setting the new name to an empty string.

## Size Limitations

As you start using Redis, you might wonder "how many keys can I have?" You might also wonder how many fields can a hash have (especially when you use it to organize your data), or how many elements can lists and sets have? Per instance, the practical limits for all of these is in the hundreds of millions.


## Replication

Redis supports replication, which means that as you write to one Redis instance (the master), one or more other instances (the slaves) are kept up-to-date by the master. To configure a slave you use either the `slaveof` configuration setting or the `slaveof` command (instances running without this configuration are or can be masters).

Replication helps protect your data by copying to different servers. Replication can also be used to improve performance since reads can be sent to slaves. They might respond with slightly out of date data, but for most apps that's a worthwhile tradeoff.

Unfortunately, Redis replication doesn't yet provide automated failover. If the master dies, a slave needs to be manually promoted. Traditional high-availability tools that use heartbeat monitoring and scripts to automate the switch are currently a necessary headache if you want to achieve some sort of high availability with Redis.

## Backups

Backing up Redis is simply a matter of copying Redis' snapshot to whatever location you want (S3, FTP, ...). By default Redis saves its snapshot to a file named `dump.rdb`. At any point in time, you can simply `scp`, `ftp` or `cp` (or anything else) this file.

It isn't uncommon to disable both snapshotting and the append-only file (aof) on the master and let a slave take care of this. This helps reduce the load on the master and lets you set more aggressive saving parameters on the slave without hurting overall system responsiveness.

## Scaling and Redis Cluster

Replication is the first tool a growing site can leverage. Some commands are more expensive than others (`sort` for example) and offloading their execution to a slave can keep the overall system responsive to incoming queries.

Beyond this, truly scaling Redis comes down to distributing your keys across multiple Redis instances (which could be running on the same box, remember, Redis is single-threaded). For the time being, this is something you'll need to take care of (although a number of Redis drivers do provide consistent-hashing algorithms). Thinking about your data in terms of horizontal distribution isn't something we can cover in this book. It's also something you probably won't have to worry about for a while, but it's something you'll need to be aware of regardless of what solution you use.

The good news is that work is under way on Redis Cluster. Not only will this offer horizontal scaling, including rebalancing, but it'll also provide automated failover for high availability.

High availability and scaling is something that can be achieved today, as long as you are willing to put the time and effort into it. Moving forward, Redis Cluster should make things much easier.

## In This Chapter

Given the number of projects and sites using Redis already, there can be no doubt that Redis is production-ready, and has been for a while. However, some of the tooling, especially around security and availability is still young. Redis Cluster, which we'll hopefully see soon, should help address some of the current management challenges.

# Conclusion

In a lot of ways, Redis represents a simplification in the way we deal with data. It peels away much of the complexity and abstraction available in other systems. In many cases this makes Redis the wrong choice. In others it can feel like Redis was custom-built for your data.

Ultimately it comes back to something I said at the very start: Redis is easy to learn. There are many new technologies and it can be hard to figure out what's worth investing time into learning. When you consider the real benefits Redis has to offer with its simplicity, I sincerely believe that it's one of the best investments, in terms of learning, that you and your team can make.
