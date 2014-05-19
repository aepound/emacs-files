; Functions to mark text for an index

; Put this in the .emacs file in the latex-mode-hook
;      (load "markindex1")
;      (local-set-key "\C-ci" index-key-map)

(defvar markindex-indexfile nil)
; if this variable is nil, don't create a file of index terms

(setq markindex-indexfile "/home/tmoon/junkindex")

; the text that is used in the index command
(defvar index-start-text "\\Index{")
(defvar index-end-text "}")
; the following is used if the word is upper case: 
;   display in upper case, but insert in index in lower case
;  command: \Index2{text Word}{index word}
(defvar index-start-text2 "\\Index2{")
(defvar index-interm-b "}{")
(defvar index-end-text2 "}")
; the register that is used to save the data
(defvar index-register 'k)

(setq index-key-map '(keymap 
                         (119 . index-word1)  ; w - index one word
                         (109 . mmark-word2)  ; m - mark a word
                         (99 . clear-index-mark)  ; c - clear the marking
                         (87 . index-word2)  ; W - index several words
                     ))

; pq marks the range of words to index
(setq pq nil)

(defun index-word1()
   "Mark a single word and put it into index form"
   (interactive "*")
   (mmark-word)
   (copy-to-register index-register (marker-position (car pq)) 
                       (marker-position (car (cdr pq))))

   (setq downword (downcase (get-register index-register)))

   (if (not (string= downword (get-register index-register)))
      ; if an upper case word
      (if (y-or-n-p (concat "Insert index word [" 
              (get-register index-register) "] in upper case? "))
          ; insert in upper case
		  (progn    ; mark the index in the buffer
            (goto-char (marker-position (car pq)))
			(insert index-start-text)           ; \Index{
;			(insert-register index-register t)  ; word
            (goto-char (marker-position (car (cdr pq))))
			(insert index-end-text)             ; }
			(setq saveword (get-register index-register))
		  )
		  ; else insert in lower case
		  (progn    ; make the index in the buffer
            (goto-char (marker-position (car pq)))
			(insert index-start-text2)          ; \Index2{
;			(insert-register index-register t)  ; Word
            (goto-char (marker-position (car (cdr pq))))
			(insert index-interm-b)             ; }{
			(insert downword)                   ; word
			(insert index-end-text2)            ; }
			(setq saveword downword)
          )
      )
      ; else a lower-case word
	 (progn 
       (goto-char (marker-position (car pq)))
       (insert index-start-text)
;       (insert-register index-register t)
       (goto-char (marker-position (car (cdr pq))))
	   (insert index-end-text)
       (setq saveword (get-register index-register))
     )
   )

   ; Now check for the buffer with the index list in it
   (if (not (eq markindex-indexfile nil))
       (progn (princ "using indexfile")
           (insert-index-word saveword)
       )
    )
   (setq pq nil)   ; clear out for next round of marking
)


(defun insert-index-word (word)
  "Put an index word into the index word buffer"
  (interactive "*")
  (setq markindexb (find-file-noselect markindex-indexfile))
  (save-excursion 
     (set-buffer markindexb)
     (goto-char 1)      ; go to the top of the file
     (setq case-fold-search t)
      ; look for the word in the other buffer
      (if(not(word-search-forward word (point-max) t))
            (progn (insert word)
               (insert "\n")
               ; sort the whole thing
               (sort-lines  nil (point-min) (point-max))
            )
      )
    )
)

(defun mmark-word()
  "Marks the word that the point is sitting on or after"
  (interactive "*")
  (move-to-wordstart)
  (setq p (point-marker))
  (forward-word 1)
  (setq q (point-marker))
  (setq pq (list p q))
)

(defun mmark-word2()
  "Marks the word that the point is sitting on or after, keeping track of multiple words; moves to next word after marking"
  (interactive "*")
  (move-to-wordstart)
  (if (null pq)
    ; if no previous mark, simple set up as usual
    (progn (setq p (point-marker)) (forward-word 1) (setq q (point-marker)))
    ; otherwise,
    (progn 
    ; if point < previous p, set new p
    (if (< (point) (marker-position (car pq)))
         (progn (setq p (point-marker)) (setq q (car (cdr pq))))
    ; else if point > previous q, set new q
         (if (> (point) (marker-position (car (cdr pq))))
             (progn (setq p (car pq)) (forward-word 1) (setq q (point-marker)))
          )
    )
    )
  )
  (forward-word 1) (backward-word 1)
  (setq pq (list p q))
)

(defun clear-index-mark()
  "Clear the marking of a word sequence"
  (interactive "*")
  (setq pq nil)
)
  
(defun move-to-wordstart()
  "Moves the point to the beginning of a word"
  (interactive "*")
  (if (not (looking-at "\\w")) (backward-char 1))
  (while (looking-at "\\w")  (backward-char 1)
   )
   (forward-char 1)
)

(defun index-word2()
   "Place marked words into index"
   (interactive "*")
   (copy-to-register index-register (marker-position (car pq)) 
                       (marker-position (car (cdr pq))))

   (setq downword (downcase (get-register index-register)))

   (if (not (string= downword (get-register index-register)))
      ; if an upper case word
      (if (y-or-n-p (concat "Insert index word [" 
              (get-register index-register) "] in upper case? "))
          ; insert in upper case
		  (progn    ; mark the index in the buffer
            (goto-char (marker-position (car pq)))
			(insert index-start-text)           ; \Index{
;			(insert-register index-register t)  ; word
            (goto-char (marker-position (car (cdr pq))))
			(insert index-end-text)             ; }
			(setq saveword (get-register index-register))
		  )
		  ; else insert in lower case
		  (progn    ; make the index in the buffer
            (goto-char (marker-position (car pq)))
			(insert index-start-text2)          ; \Index2{
;			(insert-register index-register t)  ; Word
            (goto-char (marker-position (car (cdr pq))))
			(insert index-interm-b)             ; }{
			(insert downword)                   ; word
			(insert index-end-text2)            ; }
			(setq saveword downword)
          )
      )
      ; else a lower-case word
	 (progn 
       (goto-char (marker-position (car pq)))
       (insert index-start-text)
;       (insert-register index-register t)
       (goto-char (marker-position (car (cdr pq))))
	   (insert index-end-text)
       (setq saveword (get-register index-register))
     )
   )

   ; Now check for the buffer with the index list in it
   (if (not (eq markindex-indexfile nil))
       (progn (princ "using indexfile")
           (insert-index-word saveword)
       )
    )
   (setq pq nil)   ; clear out for next round of marking
)
