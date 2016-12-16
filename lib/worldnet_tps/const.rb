module WorldnetTps
  module Const
    #TERMINALTYPE Y The type of the terminal:
    TERM_MOTO = 1
    TERM_INTERNET = 2 #- eCommerce

    #TRANSACTIONTYPE Y Normally:
    TRANS_MOTO = 4 #MOTO (Mail Order/Telephone Order)
    TRANS_INTERNET = 7 #eCommerce
    #Recurring Payment Flagging:
    # Specify that this transaction is recurring.
    # This must be accompanied by the RECURRINGTXNREF field or have special permission granted by the Gateway.
    # Not all processors support this transaction type and consultation with the integration team should be carried out
    # prior to configuring recurring payment flagging.
    TRANS_RECURRING = 2
    #For First Data Latvia terminal MOTO transactions:
    # 4 - Telephone Order
    TRANS_TELEPHONE = 4
    # 9 - Mail Order
    TRANS_MAIL = 9

    #If sending XID & CAVV from non-WorldNet
    #MPI on an Internet transaction use:
    TRANS_NOT_APPLICABLE = 0
    TRANS_SINGLE = 1
    #TRANS_RECURRING = 2 (already defined)
    TRANS_INSTALLMENT = 3
    TRANS_UNKNOWN = 4
    TRANS_3D_SECURED = 5
    #Secure transaction

    #•6 - The merchant attempted to authenticate the cardholder,
    # but the cardholder cannot or does not participate in 3D-Secure.
    TRANS_NO_3D_SECURED = 6
    #7 - Transaction when payment data was transmitted using SSL
    TRANS_ENCRYPTED = 7
    #8 - Transaction in the clear, or Non
    TRANS_IN_CLEAR_OR_NON = 8

    SECURECARD = 'SECURECARD'.freeze
  end
end