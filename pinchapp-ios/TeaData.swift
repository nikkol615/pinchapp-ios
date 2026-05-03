import Foundation

struct Steep: Identifiable {
    let id: Int
    let number: Int
    let seconds: Int
    let note: String
    let isRinse: Bool
}

struct TeaType: Identifiable {
    let id: String
    let name: String
    let description: String
    let steeps: [Steep]
}

enum TeaData {
    static let all: [TeaType] = [shuPuer, shengPuer, darkOolong, lightOolong, redTea, whiteTea]

    static let shuPuer = TeaType(
        id: "shu_puer",
        name: "Шу Пуэр",
        description: "Качественный шу пуэр очень плотный и выносливый. Долго держит «нефтяной» цвет, затем плавно уходит в древесную сладость.",
        steeps: [
            Steep(id: 0, number: 0, seconds: 7,   note: "Пробуждение прессованного листа — слить!",    isRinse: true),
            Steep(id: 1, number: 1, seconds: 5,   note: "Быстрый пролив",                               isRinse: false),
            Steep(id: 2, number: 2, seconds: 5,   note: "",                                             isRinse: false),
            Steep(id: 3, number: 3, seconds: 10,  note: "Выход на пик вкуса и цвета",                  isRinse: false),
            Steep(id: 4, number: 4, seconds: 15,  note: "",                                             isRinse: false),
            Steep(id: 5, number: 5, seconds: 20,  note: "",                                             isRinse: false),
            Steep(id: 6, number: 6, seconds: 30,  note: "",                                             isRinse: false),
            Steep(id: 7, number: 7, seconds: 45,  note: "",                                             isRinse: false),
            Steep(id: 8, number: 8, seconds: 60,  note: "Цвет начинает светлеть",                      isRinse: false),
            Steep(id: 9, number: 9, seconds: 90,  note: "Появляется сладкая вода",                     isRinse: false),
            Steep(id: 10, number: 10, seconds: 120, note: "",                                           isRinse: false),
            Steep(id: 11, number: 11, seconds: 180, note: "",                                           isRinse: false),
            Steep(id: 12, number: 12, seconds: 300, note: "Завершающий — выжимаем остатки сладости",   isRinse: false),
        ]
    )

    static let shengPuer = TeaType(
        id: "sheng_puer",
        name: "Шэн Пуэр",
        description: "Рекордсмен по выносливости, особенно со старых деревьев. На поздних проливах горечь уходит, оставляя потрясающее сладкое послевкусие.",
        steeps: [
            Steep(id: 0, number: 0, seconds: 4,   note: "Промывка — слить!",                           isRinse: true),
            Steep(id: 1, number: 1, seconds: 4,   note: "Очень быстро, чтобы не ушёл в горечь",        isRinse: false),
            Steep(id: 2, number: 2, seconds: 5,   note: "",                                             isRinse: false),
            Steep(id: 3, number: 3, seconds: 10,  note: "",                                             isRinse: false),
            Steep(id: 4, number: 4, seconds: 15,  note: "",                                             isRinse: false),
            Steep(id: 5, number: 5, seconds: 20,  note: "",                                             isRinse: false),
            Steep(id: 6, number: 6, seconds: 30,  note: "",                                             isRinse: false),
            Steep(id: 7, number: 7, seconds: 45,  note: "",                                             isRinse: false),
            Steep(id: 8, number: 8, seconds: 60,  note: "",                                             isRinse: false),
            Steep(id: 9, number: 9, seconds: 80,  note: "Вкус становится более мягким и фруктовым",    isRinse: false),
            Steep(id: 10, number: 10, seconds: 120, note: "",                                           isRinse: false),
            Steep(id: 11, number: 11, seconds: 180, note: "",                                           isRinse: false),
            Steep(id: 12, number: 12, seconds: 270, note: "Можно держать дольше — лист уже не даст горечи", isRinse: false),
        ]
    )

    static let darkOolong = TeaType(
        id: "dark_oolong",
        name: "Тёмный улун (Да Хун Пао)",
        description: "Утёсные улуны отдают много вкуса и эфирных масел в середине чаепития, но «исписываются» быстрее пуэров.",
        steeps: [
            Steep(id: 0, number: 0, seconds: 5,   note: "Промывка — слить!",                            isRinse: true),
            Steep(id: 1, number: 1, seconds: 7,   note: "Лёгкий «приветственный» настой",               isRinse: false),
            Steep(id: 2, number: 2, seconds: 10,  note: "Раскрытие огненных и печёных нот",             isRinse: false),
            Steep(id: 3, number: 3, seconds: 15,  note: "Пик вкуса — самая яркая чашка",                isRinse: false),
            Steep(id: 4, number: 4, seconds: 20,  note: "",                                              isRinse: false),
            Steep(id: 5, number: 5, seconds: 30,  note: "",                                              isRinse: false),
            Steep(id: 6, number: 6, seconds: 45,  note: "",                                              isRinse: false),
            Steep(id: 7, number: 7, seconds: 60,  note: "Терпкость спадает, чай становится водянистым", isRinse: false),
            Steep(id: 8, number: 8, seconds: 90,  note: "",                                              isRinse: false),
            Steep(id: 9, number: 9, seconds: 150, note: "Завершающий пролив",                           isRinse: false),
        ]
    )

    static let lightOolong = TeaType(
        id: "light_oolong",
        name: "Светлый улун (Те Гуань Инь)",
        description: "«Те Гуань Инь выдерживает 7 завариваний, и даже тогда аромат остаётся» — китайская пословица.",
        steeps: [
            Steep(id: 0, number: 0, seconds: 5,   note: "Прогрев скрученных шариков — слить!",         isRinse: true),
            Steep(id: 1, number: 1, seconds: 15,  note: "Шарикам нужно время начать разворачиваться",  isRinse: false),
            Steep(id: 2, number: 2, seconds: 10,  note: "Лист раскрылся — проливаем быстрее",          isRinse: false),
            Steep(id: 3, number: 3, seconds: 15,  note: "Пик сиренево-цветочного аромата",             isRinse: false),
            Steep(id: 4, number: 4, seconds: 20,  note: "",                                             isRinse: false),
            Steep(id: 5, number: 5, seconds: 30,  note: "",                                             isRinse: false),
            Steep(id: 6, number: 6, seconds: 45,  note: "",                                             isRinse: false),
            Steep(id: 7, number: 7, seconds: 60,  note: "",                                             isRinse: false),
            Steep(id: 8, number: 8, seconds: 120, note: "Последний лёгкий цветочный настой",           isRinse: false),
        ]
    )

    static let redTea = TeaType(
        id: "red_tea",
        name: "Красный чай (Дянь Хун)",
        description: "Экстрагируется очень активно. Даёт яркий, мощный вкус в начале, но ресурс исчерпывается быстрее всего.",
        steeps: [
            Steep(id: 0, number: 0, seconds: 3,   note: "Моментальная промывка — слить!",              isRinse: true),
            Steep(id: 1, number: 1, seconds: 5,   note: "",                                             isRinse: false),
            Steep(id: 2, number: 2, seconds: 5,   note: "Пик плотности и терпкости",                   isRinse: false),
            Steep(id: 3, number: 3, seconds: 10,  note: "",                                             isRinse: false),
            Steep(id: 4, number: 4, seconds: 15,  note: "",                                             isRinse: false),
            Steep(id: 5, number: 5, seconds: 25,  note: "",                                             isRinse: false),
            Steep(id: 6, number: 6, seconds: 45,  note: "Вкус слабеет — уходит в медовую воду",        isRinse: false),
            Steep(id: 7, number: 7, seconds: 105, note: "Дальше заваривать смысла обычно нет",         isRinse: false),
        ]
    )

    static let whiteTea = TeaType(
        id: "white_tea",
        name: "Белый чай (Бай Му Дань)",
        description: "Самый слабоферментированный. Лист целый, часто с пушком. Отдаёт вкус нехотя, плавно — время выдержки растёт быстрее, ресурс большой.",
        steeps: [
            Steep(id: 0, number: 0, seconds: 5,   note: "Промывка — слить!",                            isRinse: true),
            Steep(id: 1, number: 1, seconds: 12,  note: "Настой прозрачный, очень тонкий",              isRinse: false),
            Steep(id: 2, number: 2, seconds: 15,  note: "",                                              isRinse: false),
            Steep(id: 3, number: 3, seconds: 20,  note: "Появляется плотность, цветочные ноты",         isRinse: false),
            Steep(id: 4, number: 4, seconds: 30,  note: "",                                              isRinse: false),
            Steep(id: 5, number: 5, seconds: 45,  note: "",                                              isRinse: false),
            Steep(id: 6, number: 6, seconds: 60,  note: "",                                              isRinse: false),
            Steep(id: 7, number: 7, seconds: 90,  note: "",                                              isRinse: false),
            Steep(id: 8, number: 8, seconds: 120, note: "",                                              isRinse: false),
            Steep(id: 9, number: 9, seconds: 180, note: "",                                              isRinse: false),
            Steep(id: 10, number: 10, seconds: 300, note: "Старый белый чай можно закинуть в чайник и сварить на огне", isRinse: false),
        ]
    )
}
