#! /usr/bin/env bash

ff_filter() {
    fontforge -c 'open(argv[1]).generate(argv[2])' "$1" "$2"
}

ttf_filter() {
    # 1 - source file
    # 2 - destination file
    BNP=${BNP:="./BitsNPicas.jar"}
    java -jar "$BNP" convertbitmap -f ttf -o "$2" "$1"
}

export_fonts() {
    for i in src/*; do
        local file_name
        file_name=$(basename "${i%.*}")
        ttf_filter "$i" "build/scientifica/ttf/$file_name.ttf"
        ff_filter "$i" "build/scientifica/otb/$file_name.otb"
        ff_filter "$i" "build/scientifica/bdf/$file_name.bdf"
    done
}

export_plugins() {
    cp -r ligature_plugins build/scientifica/ligature_plugins
}

main() {
    rm -rf build
    mkdir -p build/scientifica/{otb,ttf,bdf}

    echo "[~] Exporting ligature plugins ..."
    export_plugins

    echo "[~] Exporting fonts ..."
    export_fonts

    echo "[~] Entering build directory ..."
    cd build || echo "[!] Failed to enter build directory!"
    tar c --file scientifica.tar scientifica
    echo "[~] Leaving build directory ..."

    echo "[!] Done!"
}

main
