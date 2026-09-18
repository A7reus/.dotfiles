function get_idf --wraps='export IDF_PATH=$HOME/esp/esp-idf && . $HOME/esp/esp-idf/export.fish' --description 'alias get_idf=export IDF_PATH=$HOME/esp/esp-idf && . $HOME/esp/esp-idf/export.fish'
  export IDF_PATH=$HOME/esp/esp-idf && . $HOME/esp/esp-idf/export.fish $argv
        
end
