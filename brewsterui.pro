# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    brewsterclient.cpp

# Installation path
# target.path =

QMAKE_CXXFLAGS += -pipe -fno-exceptions -fstack-protector -Wl,-z,relro -Wl,-z,now \
                  -Wformat-security -Wpointer-arith -Wformat-nonliteral -Winit-self -Werror

QMAKE_LFLAGS += -Wl,-O1 -Wl,--discard-all -Wl,--no-undefined -rdynamic

QT += qml quick websockets

HEADERS += \
    brewsterclient.h

OTHER_FILES += \
    qml/main.qml \
    qml/connectdialog.qml \
    qml/brewsterui.qml \
    qml/ToggleSwitch.qml \
    qml/BrewChart.qml

RESOURCES += \
    brewsterui.qrc
