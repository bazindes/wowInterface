local L = AceLibrary("AceLocale-2.2"):new("RicoMM")

L:RegisterTranslations("enUS", function() return {
	["Locked"] = true,
	["Prevent dragging the map or buttons"] = true,
	["Show Coordinates"] = true,
	["Show your location coordiates"] = true,
	["Show Coordinate Tenths"] = true,
	["Show your location with tenths"] = true,
	["Coordinates Position"] = true,
	["Choose the location of the coordinates"] = true,
	["Inside Top"] = true,
	["Outside Top"] = true,
	["Inside Bottom"] = true,
	["Outside Bottom"] = true,
	["Show Zoom Buttons"] = true,
	["Show the zoom in and zoom out buttons"] = true,
	["Show Map Button"] = true,
	["Show the world map button"] = true,
	["Show Time Button"] = true,
	["Show the time button"] = true,
	["Show Tracking Button"] = true,
	["Show the tracking button"] = true,
	["Show Mail Button"] = true,
	["Show the mail button"] = true,
	["Show Zone Text"] = true,
	["Show the default zone text"] = true,
	["Show Minimap Border"] = true,
	["Toggle the minimap border"] = true,
	["Show Menu"] = true,
	["Toggle showing the menu on right-click.  '/rmm menu' to re-enable"] = true,
	["Shape"] = true,
	["Choose the shape of the minimap"] = true,
	["Bottom Left"] = true,
	["Bottom Left corner is rounded"] = true,
	["Square"] = true,
	["All four corners square"] = true,
	["Round"] = true,
	["All four corners round"] = true,
	["Strata"] = true,
	["Change the minimap strata"] = true,
	["Scale"] = true,
	["Scale the minimap from 50% to 250% in 1% increments"] = true,
	["Transparency"] = true,
	["Set the transparency of the MiniMap"] = true,
	["Zone Text Location"] = true,
	["Set the location of the zone text"] = true,
	["A customizable MiniMap"] = true,
	["config"] = true,
	["Open the config menu."] = true,
	["reset"] = true,
	["Reset the minimap's position."] = true,
	["menu"] = true,
	["Enable the menu on right-click."] = true,
	["hide"] = true,
	["Hide the entire minimap."] = true,
	["show"] = true,
	["Show the minimap."] = true,
	["PingNotificationType"] = true, 
	["Choose the ping notification type"] = true,
	["None"] = true,
	["Don't display who pinged."] = true,
	["Default Chat"] = true,
	["Identify who pinged in default chat."] = true,
	["WatchFrameScale"] = true,
	["WatchFrameHeight"] = true,
	["Scale the WatchFrame from 50% to 150% in 1% increments"] = true,
	["Set the WatchFrame height to show more quests"] = true,
	["ShowClock"] = true,
}end)

L:RegisterTranslations("zhCN", function() return {
	["Locked"] = "锁定",
	["Prevent dragging the map or buttons"] = "防止拖动小地图或者按钮",
	["Show Coordinates"] = "显示坐标",
	["Show your location coordiates"] = "显示你当前的坐标",
	["Show Coordinate Tenths"] ="显示高精度坐标",
	["Show your location with tenths"] ="使用高精度显示你当前的坐标",
	["Coordinates Position"] = "坐标位置",
	["Choose the location of the coordinates"] = "选择坐标显示位置",
	["Inside Top"] = "顶部内置",
	["Outside Top"] = "顶部外置",
	["Inside Bottom"] = "底部内置",
	["Outside Bottom"] = "底部外置",
	["Show Zoom Buttons"] = "显示缩放按钮",
	["Show the zoom in and zoom out buttons"] = "显示小地图的缩放按钮",
	["Show Map Button"] = "显示地图按钮",
	["Show the world map button"] = "显示世界地图按钮",
	["Show Time Button"] = "显示时间按钮",
	["Show the time button"] = "显示系统时间按钮",
	["Show Tracking Button"] = true,
	["Show the tracking button"] = true,
	["Show Mail Button"] = true,
	["Show the mail button"] = true,
	["Show Zone Text"] = "显示区域名称",
	["Show the default zone text"] = "显示默认区域名称",
	["Show Minimap Border"] = "显示小地图边框",
	["Toggle the minimap border"] = "切换显示小地图边框",
	["Show Menu"] = "显示目录",
	["Toggle showing the menu on right-click.  '/rmm menu' to re-enable"] = "切换右击小地图显示目录,输入'/rmm 目录'重新启用",
	["Shape"] = "形状",
	["Choose the shape of the minimap"] = "选择小地图形状",
	["Bottom Left"] = "1/4圆弧形",
	["Bottom Left corner is rounded"] = "底部左边为圆弧形",
	["Square"] = "正方形",
	["All four corners square"] = "正方形",
	["Round"] = "圆形",
	["All four corners round"] = "圆形",
	["Strata"] = "层次",
	["Change the minimap strata"] = "改变小地图层次",
	["Scale"] = "缩放",
	["Scale the minimap from 50% to 250% in 1% increments"] = "小地图缩放范围为50%~250.",
	["Transparency"] = "透明度",
	["Set the transparency of the MiniMap"] = "设置小地图透明度",
	["Zone Text Location"] = "区域名称位置",
	["Set the location of the zone text"] = "设置区域名称位置",
	["A customizable MiniMap"] = "自定义小地图插件.",
	["config"] = "设置",
	["Open the config menu."] = "打开设置目录",
	["reset"] = "重置",
	["Reset the minimap's position."] = "重置小地图位置",
	["menu"] = "目录",
	["Enable the menu on right-click."] = "启用右击显示目录",
	["hide"] = "隐藏",
	["Hide the entire minimap."] = "隐藏小地图",
	["show"] = "显示",
	["Show the minimap."] = "显示小地图",
	["WatchFrameScale"] = "WatchFrameScale",
	["WatchFrameHeight"] = "WatchFrameHeight",
	["Scale the WatchFrame from 50% to 150% in 1% increments"] = "Scale the WatchFrame from 50% to 150% in 1% increments",
	["Set the WatchFrame height to show more quests"] = "Set the WatchFrame height to show more quests",
	["ShowClock"] = "ShowClock",
}end)

-- Russian Translation by StingerSoft (Eritnull aka Шептун)
L:RegisterTranslations("ruRU", function() return {
	["Locked"] = "Закрепить",
	["Prevent dragging the map or buttons"] = "Закрепляет расположение мини-карты",
	["Show Coordinates"] = "Показать Координаты",
	["Show your location coordiates"] = "Показать координаты вашего местонахождения",
	["Show Coordinate Tenths"] = "Показать десятая часть",
	["Show your location with tenths"] = "Показать координаты вашего местонахождения с десятичным числом",
	["Coordinates Position"] = "Позиция Координат",
	["Choose the location of the coordinates"] = "Выбор позиции координат",
	["Inside Top"] = "В верхней части-внутри",
	["Outside Top"] = "В верхней части-снаружы",
	["Inside Bottom"] = "В нижней части-внутри",
	["Outside Bottom"] = "В нижней части-снаружы",
	["Show Zoom Buttons"] = "Показать кнопки масштабирования",
	["Show the zoom in and zoom out buttons"] = "Показать кнопки увеличения-уменьшения масштаба",
	["Show Map Button"] = "Показать кнопку карты",
	["Show the world map button"] = "Показать кнопку мировой карты",
	["Show Time Button"] = "Показать кнопку часов",
	["Show the time button"] = "Показать кнопку часов",
	["Show Tracking Button"] = true,
	["Show the tracking button"] = true,
	["Show Mail Button"] = true,
	["Show the mail button"] = true,
	["Show Zone Text"] = "Показать название зоны",
	["Show the default zone text"] = "Показать стандартное название зоны",
	["Show Minimap Border"] = "Показать края мини-карты",
	["Toggle the minimap border"] = "Переключает края мини-карты",
	["Show Menu"] = "Показать меню",
	["Toggle showing the menu on right-click.  '/rmm menu' to re-enable"] = "Отображение меню на ПКМ. '/rmm menu' для перевключения",
	["Shape"] = "Вид",
	["Choose the shape of the minimap"] = "Выбор вида мини-карты",
	["Bottom Left"] = "Снизу слева",
	["Bottom Left corner is rounded"] = "Закруглённый угол снизу-слева",
	["Square"] = "Квадрат",
	["All four corners square"] = "Все 4 угла квадратных",
	["Round"] = "Круг",
	["All four corners round"] = "Все 4 угла круглых",
	["Strata"] = "Слои",
	["Change the minimap strata"] = "Изменяет приоритет окна в противоположность другим окнам (препятствует, чтобы 2 окна имели тот же самый приоритет и накладывались таким образом)",
	["Scale"] = "Маштаб",
	["Scale the minimap from 50% to 250% in 1% increments"] = "Масштаб мини-карты от 50% до 250% по 1% прироста",
	["Transparency"] = "Прозрачность",
	["Set the transparency of the MiniMap"] = "Установка прозрачности мини-карты",
	["Zone Text Location"] = "Позиция названия зоны",
	["Set the location of the zone text"] = "Установка позиции названия зоны",
	["A customizable MiniMap"] = "Настройка Мини-Карты",
	["config"] = "Настройка",
	["Open the config menu."] = "Открыть меню настройки",
	["reset"] = "Сбросс",
	["Reset the minimap's position."] = "Сбросить позицию мини-карты",
	["menu"] = "Меню",
	["Enable the menu on right-click."] = "Включить меню по клику ПКМ",
	["hide"] = "Скрыть",
	["Hide the entire minimap."] = "Скрыть мини-карту",
	["show"] = "Показать",
	["Show the minimap."] = "Показать мини-карту",
	["WatchFrameScale"] = "WatchFrameScale",
	["WatchFrameHeight"] = "WatchFrameHeight",
	["Scale the WatchFrame from 50% to 150% in 1% increments"] = "Scale the WatchFrame from 50% to 150% in 1% increments",
	["Set the WatchFrame height to show more quests"] = "Set the WatchFrame height to show more quests",
	["ShowClock"] = "ShowClock",
}end)