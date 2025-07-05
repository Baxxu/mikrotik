# Скрипты и конфиги для MikroTik роутера
Жми Quick Set.

# video.rsc
Добавляет IP адреса в список video, чтобы потом в firewall -> mangle можно было применять прявила к этому списку адресов.

В списке video хранятся адреса, которым нужно повышать приоритеть пакетов до 24, чтобы они попадали в video очередь cake queue.

# setup.rsc
Положи файлы setup.rsc и video.rsc в микротик и выполни в нём команду.

/import file-name=setup.rsc verbose=yes

# WiFi
Не забудь поставить страну в Quick Setup
