; portable regular expressions library test

(use 'test)
(use 'pregexp)

(define date-re
  ;match `month year' or `month day, year'.
  ;subpattern matches day, if present
  (pregexp "([a-z]+) +([0-9]+,)? *([0-9]+)"))

(define n0-255
  "(?x:
     \\d          ;  0 through   9
     | \\d\\d     ; 00 through  99
     | [01]\\d\\d ;000 through 199
     | 2[0-4]\\d  ;200 through 249
     | 25[0-5]    ;250 through 255
     )")

(define ip-re1
  (string-append
    "^"        ;nothing before
    n0-255     ;the first n0-255,
    "(?x:"     ;then the subpattern of
    "\\."      ;a dot followed by
    n0-255     ;an n0-255,
    ")"        ;which is
    "{3}"      ;repeated exactly 3 times
    "$"        ;with nothing following
    ))

(define ip-re
  (string-append
    "(?=[1-9])" ;ensure there's a non-0 digit
    ip-re1))

(check (pregexp "c.r") => '(:sub (:or (:seq #\c :any #\r))))
(check (pregexp-match-positions "brain" "bird") => #f)
(check (pregexp-match-positions "needle" "hay needle stack") => '((4 . 10)))
(check (pregexp-match-positions "needle" "his hay needle stack -- my hay needle stack -- her hay needle stack" 24 43) => '((31 . 37)))
(check (pregexp-match "brain" "bird") => #f)
(check (pregexp-match "needle" "hay needle stack") => '("needle"))
(check (pregexp-split ":" "/bin:/usr/bin:/usr/bin/X11:/usr/local/bin") => '("/bin" "/usr/bin" "/usr/bin/X11" "/usr/local/bin"))
(check (pregexp-split " " "pea soup") => '("pea" "soup"))
(check (pregexp-split "" "smithereens") => '("s" "m" "i" "t" "h" "e" "r" "e" "e" "n" "s"))
(check (pregexp-split " +" "split pea     soup") => '("split" "pea" "soup"))
(check (pregexp-split " *" "split pea     soup") => '("s" "p" "l" "i" "t" "p" "e" "a" "s" "o" "u" "p"))
(check (pregexp-replace "te" "liberte" "ty") => "liberty")
(check (pregexp-replace* "te" "liberte egalite fraternite" "ty") => "liberty egality fratyrnity")
(check (pregexp-match-positions "^contact" "first contact") => #f)
(check (pregexp-match-positions "laugh$" "laugh laugh laugh laugh") => '((18 . 23)))
(check (pregexp-match-positions "yack\\b" "yackety yack") => '((8 . 12)))
(check (pregexp-match-positions "an\\B" "an analysis") => '((3 . 5)))
(check (pregexp-match "p.t" "pet") => '("pet"))
(check (pregexp-match "\\d\\d" "0 dear, 1 have to read catch 22 before 9") => '("22"))
(check (pregexp-match "[[:alpha:]_]" "--x--") => '("x"))
(check (pregexp-match "[[:alpha:]_]" "--_--") => '("_"))
(check (pregexp-match "[[:alpha:]_]" "--:--") => #f)
(check (pregexp-match "[:alpha:]" "--a--") => '("a"))
(check (pregexp-match "[:alpha:]" "--_--") => #f)
(check (pregexp-match-positions "c[ad]*r" "cadaddadddr") => '((0 . 11)))
(check (pregexp-match-positions "c[ad]*r" "cr") => '((0 . 2)))
(check (pregexp-match-positions "c[ad]+r" "cadaddadddr") => '((0 . 11)))
(check (pregexp-match-positions "c[ad]+r" "cr") => #f)
(check (pregexp-match-positions "c[ad]?r" "cadaddadddr") => #f)
(check (pregexp-match-positions "c[ad]?r" "cr") => '((0 . 2)))
(check (pregexp-match-positions "c[ad]?r" "car") => '((0 . 3)))
(check (pregexp-match "<.*>" "<tag1> <tag2> <tag3>") => '("<tag1> <tag2> <tag3>"))
(check (pregexp-match "<.*?>" "<tag1> <tag2> <tag3>") => '("<tag1>"))
(check (pregexp-match "([a-z]+) ([0-9]+), ([0-9]+)" "jan 1, 1970") => '("jan 1, 1970" "jan" "1" "1970"))
(check (pregexp-match "(poo )*" "poo poo platter") => '("poo poo " "poo "))
(check (pregexp-match "([a-z ]+;)*" "lather; rinse; repeat;") => '("lather; rinse; repeat;" " repeat;"))
(check (pregexp-match date-re "jan 1, 1970") => '("jan 1, 1970" "jan" "1," "1970"))
(check (pregexp-match date-re "jan 1970") => '("jan 1970" "jan" #f "1970"))
(check (pregexp-replace "_(.+?)_" "the _nina_, the _pinta_, and the _santa maria_" "*\\1*") => "the *nina*, the _pinta_, and the _santa maria_")
(check (pregexp-replace* "_(.+?)_" "the _nina_, the _pinta_, and the _santa maria_" "*\\1*") => "the *nina*, the *pinta*, and the *santa maria*")
(check (pregexp-replace "(\\S+) (\\S+) (\\S+)" "eat to live" "\\3 \\2 \\1") => "live to eat")
(check (pregexp-match "([a-z]+) and \\1" "billions and billions") => '("billions and billions" "billions"))
(check (pregexp-match "([a-z]+) and \\1" "billions and millions") => #f)
(check (pregexp-replace* "(\\S+) \\1" "now is the the time for all good men to to come to the aid of of the party" "\\1") => "now is the time for all good men to come to the aid of the party")
(check (pregexp-replace* "(\\d+)\\1" "123340983242432420980980234" "{\\1,\\1}") => "12{3,3}40983{24,24}3242{098,098}0234")
(check (pregexp-match "^(?:[a-z]*/)*([a-z]+)$" "/usr/local/bin/mzscheme") => '("/usr/local/bin/mzscheme" "mzscheme"))
(check (pregexp-match "(?i:hearth)" "HeartH") => '("HeartH"))
(check (pregexp-match "(?x: a   lot)" "alot") => '("alot"))
(check (pregexp-match "(?x: a  \\  lot)" "a lot") => '("a lot"))
(check (pregexp-match "(?i:the (?-i:TeX)book)" "The TeXbook") => '("The TeXbook"))
(check (pregexp-match "f(ee|i|o|um)" "a small, final fee") => '("fi" "i"))
(check (pregexp-replace* "([yi])s(e[sdr]?|ing|ation)" "it is energising to analyse an organisation pulsing with noisy organisms" "\\1z\\2") => "it is energizing to analyze an organization pulsing with noisy organisms")
(check (pregexp-match "f(?:ee|i|o|um)" "fun for all") => '("fo"))
(check (pregexp-match "call|call-with-current-continuation" "call-with-current-continuation") => '("call"))
(check (pregexp-match "call-with-current-continuation|call" "call-with-current-continuation") => '("call-with-current-continuation"))
(check (pregexp-match "(?:call|call-with-current-continuation) constrained" "call-with-current-continuation constrained") => '("call-with-current-continuation constrained"))
(check (pregexp-match "(?>a+)." "aaaa") => #f)
(check (pregexp-match-positions "grey(?=hound)" "i left my grey socks at the greyhound") => '((28 . 32)))
(check (pregexp-match-positions "grey(?!hound)" "the gray greyhound ate the grey socks") => '((27 . 31)))
(check (pregexp-match-positions "(?<=grey)hound" "the hound in the picture is not a greyhound") => '((38 . 43)))
(check (pregexp-match-positions "(?<!grey)hound" "the greyhound in the picture is not a hound") => '((38 . 43)))

(check (pregexp-match "a[^a]*b" "glauber") => '("aub"))
(check (pregexp-match "a([^a]*)b" "glauber") => '("aub" "u"))
(check (pregexp-match "a([^a]*)b" "ababababab") => '("ab" ""))
(check (pregexp-match "(?x: s  e  * k )" "seeeeek") => '("seeeeek"))
(check (pregexp-replace* "^(.*)$" "foobar" "\\1abc") => "foobarabc")
(check (pregexp-replace* "^(.*)$" "foobar" "abc\\1") => "abcfoobar")
(check (pregexp-replace* "(.*)$" "foobar" "abc\\1") => "abcfoobar")
(check (pregexp "[a-z-]") => '(:sub (:or (:seq (:one-of-chars (:char-range #\a #\z) #\-)))))
(check (pregexp "[-a-z]") => '(:sub (:or (:seq (:one-of-chars #\- (:char-range #\a #\z))))))
(check (pregexp-match-positions "(a(b))?c" "abc") => '((0 . 3) (0 . 2) (1 . 2)))
(check (pregexp-match-positions "(a(b))?c" "c") => '((0 . 1) #f #f))
(check (length (pregexp-match "(a)|(b)" "b")) => 3)
(check (pregexp "[-a]") => '(:sub (:or (:seq (:one-of-chars #\- #\a)))))
(check (pregexp "[a-]") => '(:sub (:or (:seq (:one-of-chars #\a #\-)))))

; produce a report
(check-report)

