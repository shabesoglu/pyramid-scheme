#lang typed/racket

(require "types.rkt")
(require "typed/dict.rkt")
(provide (all-defined-out))

(: vm-exec-bytecode (-> vm-exec Bytes))
(define (vm-exec-bytecode vm) (vm-exec-environment-bytecode (vm-exec-env vm)))

(: simres-account-balance (-> simulation-result Address EthWord))
(define (simres-account-balance simres addr)
  (let* ([ receipt (simulation-result-txn-receipt simres) ]
         [ world (vm-txn-receipt-post-transaction receipt) ]
         [ acc : (U vm-account #f) (hash-ref world addr #f)]
         )
    (if acc
        (vm-account-balance acc)
        0)))

(: simres-sender-value (-> simulation-result EthWord))
(define (simres-sender-value simres)
  (let* ([ vm     (simulation-result-vm simres) ]
         [ env    (vm-exec-env vm) ]
         [ sender (vm-exec-environment-sender env) ])
    (simres-account-balance simres sender)))

(: simres-contract-value (-> simulation-result EthWord))
(define (simres-contract-value simres)
  (let* ([ vm     (simulation-result-vm simres) ]
         [ env    (vm-exec-env vm) ]
         [ contract (vm-exec-environment-contract env) ])
    (simres-account-balance simres contract)))