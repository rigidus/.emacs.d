#!/bin/sh
# Этот файл предназначен для поиска дупликатов файлов из бэкапов,
# в первую очередь повторящихся книг, возможно с разными именами,
# под которыми они были сохранены.
#
# 1. Перечисляем все файлы рекурсивно от текущей директории
#    вглубь, получаем размер и вычисляем хэш
## find . -type f -exec sh -c 'printf "%010d %s " $(stat -c %s "$1") && sha256sum "$1"' _ {} \; > output.txt
# 2. Сортируем по хэшу
sort -k2,2 output.txt -o sorted_output.txt
# 3. Этот скрипт удаляет все строки с уникальным хэшем
#    из отсортированного по хэшу файла:
#       инициализирует переменные при первой строке и затем
#       сравнивает хеш каждой строки с хешем предыдущей строки.
#          Если хеш совпадает ($2 == last_hash), строка
#            добавляется в буфер, и счетчик для этого хеша
#            увеличивается.
#          Если хеш следующей строки отличается, сначала
#            проверяется счетчик:
#              если он больше 1, содержимое буфера (строки
#                 с повторяющимися хешами) - выводится,
#              иначе (если счетчик равен 1) содержимое буфера
#                 (строка с уникальным хэшем) игнорируется.
#       В конце файла проверяется, не осталась ли последняя
#          группа строк невыведенной.
#       Если последний счетчик больше 1, выводится последний буфер.
awk '{
    if (NR == 1) {
        last_hash = $2;
        buffer = $0;
        count = 1;
    } else {
        if ($2 == last_hash) {
            buffer = buffer "\n" $0;
            count++;
        } else {
            if (count > 1) {
                print buffer;
            }
            buffer = $0;
            count = 1;
        }
    }
    last_hash = $2;
}
END {
    if (count > 1) {
        print buffer;
    }
}' sorted_output.txt > filtered_output.txt
# Сортируем файлы по размеру (а внутри размера - по хэшу, чтобы были более заметны отличающиеся хэши)
sort -k1,1n -k2,2 filtered_output.txt > sorted_filtered_output.txt
awk '{
    if (last_size != $1 || last_hash != $2) {
        if (NR > 1) print "";  # Вывод пустой строки перед новой группой
    }
    print;  # Вывод текущей строки
    last_size = $1;
    last_hash = $2;
} END {
    print "";  # Добавление пустой строки в конец файла
}' sorted_filtered_output.txt > final_output.txt
# Посчитаем сколько места удастся осовободить если удалить все неуникальные файлы
awk '{
    if (last_size == $1 && last_hash == $2) {
        # Накапливаем сумму размеров файлов в текущей группе
        space_saved += $1;
    } else {
        # Сброс при изменении размера или хеша (новая группа)
        if (NR > 1) {
            # Вычитаем размер одного файла, чтобы не учитывать его как удалённый
            total_saved += (space_saved - last_size);
        }
        space_saved = 0;  # Сброс накопленного размера для новой группы
    }
    last_size = $1;  # Сохраняем размер последнего файла
    last_hash = $2;  # Сохраняем хеш последнего файла
} END {
    # Учитываем последнюю группу файлов
    if (space_saved > 0) {
        total_saved += (space_saved - last_size);
    }
    print "Total space that can be saved: " total_saved " bytes";
    # Преобразуем байты в мегабайты
    total_saved_mb = total_saved / 1048576;
    printf "Total space that can be saved: %.2f MB\n", total_saved_mb;
    # Преобразуем байты в гигабайты
    total_saved_gb = total_saved / 1073741824;
    printf "Total space that can be saved: %.3f GB\n", total_saved_gb;
    # Преобразуем байты в терабайты
    total_saved_tb = total_saved / 1099511627776;
    printf "Total space that can be saved: %.4f TB\n", total_saved_tb;
}' sorted_filtered_output.txt
