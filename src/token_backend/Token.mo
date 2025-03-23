import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";

import Principal "mo:base/Principal";
import Time "mo:base/Time";

import CertifiedData "mo:base/CertifiedData";
import CertTree "mo:cert/CertTree";

import ICRC1 "mo:icrc1-mo/ICRC1";
import ICRC2 "mo:icrc2-mo/ICRC2";
import ICRC3 "mo:icrc3-mo/";
import ICRC4 "mo:icrc4-mo/ICRC4";

shared ({ caller = _owner }) actor class Token  (args: ?{
    icrc1 : ?ICRC1.InitArgs;
    icrc2 : ?ICRC2.InitArgs;
    icrc3 : ICRC3.InitArgs; //already typed nullable
    icrc4 : ?ICRC4.InitArgs;
  }
) = this{

    let default_icrc1_args : ICRC1.InitArgs = {
      name = ?"Quantum Leap Labs";
      symbol = ?"QLL";
      logo = ?"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAAH7+Yj7AAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAKKADAAQAAAABAAAAKAAAAAB65masAAANyElEQVRYCYWYe4xdRR3Hv+fc19677+22u7Rb2u0DKAUsVGvaqG1BCBqlSGl9JkaNGkMMRqNR/3FjNBoTUdTEF+ofxmCKRK0BoQYotFBAgUItUEppsaV0u91X9+69u+eeh5/fnHu3u1BxdufOnDkzv/n+nvObI9VLksinevbofpIDH06CyQuVf/0l6Uy0308G5CupafLoQxr3MjZvja9vKbEF3uIPKem91i1Olz+q5aptfVnDkdT7lx6j60qyQ7bWFS95SFmVbq6Nlj6pzv13SEf+mvHVt/2V0WCD4ue+qdHLPiG9Vyt9De7YXiiNKLdwszqP/EiKFMiB3tN1a/L3G5Nkr24yKG53o578UjlduW1MlaSkSixaaXr6Nn3s3q8yK05hPtS2Qt3XHx7xPi3/9BPS1GuKWy9Ry8Qx5Y8fk9bu7PAd5EXX3K14Wpo8rkz5YUWj+5SdeELl3ndJPjxWtbTB+AK1bn1RU0GnqsNSEEC1IJ3tkLr3fUbzRv54DqPJ9ANq1ZR6EWSTYp1Vswb1dlWZlMxMdAyZoHewwMp2xwAcpSXd2iY82jNfes+g49a4rjLnwj+XvA0gpKSr989bqKaNgybF8fk3q9yziVcwcWhLJbkfABQvOai8Mh+ZViXQSOXd8iZPIF0EN3+duvb/HnlqUkN/a8vqtNrUm2g8u03+5BOKzjxgBOTnIJSdolds1kblfRSfsxeZ5CSUatZ1xXM2FKYPgTJZoFRNky3hLo22bVU2b+tyitsuk06gpdLZ+9SnWmo/Oa1X882PqDKKsCfQMXPLbQi8JPXvXKXNOuR7mxWqpmc08af3Su1TChcx8QJA1h7Ryp1vRwVH5gjccT+u+Sybh9AiNHNapzTibTc5maDfUMz24MPT85h0eVGrqut+AMJNCr0eBeGziqduU8/99wKvpk2KYG9Ge3MIOkI74HbF5vXyFuxWwIgJq4Y2Q6r1Q8awK9DxTD+KT2nJzpUQrpiKGE0RJmZg16tFnR8+xc5FRbYQhTZ/HoWeZPFZm4twW6V8uwpnX1Lp+OOMYyi2ce/zV2nFywe12qRtRPdCbP4NdygubVeIE8aLNTm9Gms4Ln/soOLqMdyypkxxqZLSMmqf1LJYnc/9FjfIpuiv+lsfYAZ9Z8017C1X+iDWLsWBJjOb0Mw46I4qqhxSHE9BMFJYOSJ/+jAsm5pBncGyMgYJVZiSWs3CrOThv3rk26kAPHVO/VRJ8yKMpk+5zovV1NGppk5Y7e7HMhc5hF6+CULEJfM4oorTOPElZfkxHHNaS9R9zXeUdG1ViORBEHhLVM5fj6fE8pBjjPzMUjpe/RmsYnzTRVqIXrZzI8MvOPMxgE6ORrSG13u6SC03/FxBrl8h6jTirmVWCJoaph9AJKC/YM8tKo0+gR8d1QmCMLbI6Lli8VC70HK7OiFuQXc+wmhnQRMbeaAI+Z0EwQgzT1GHENcE4ca2Yse62ZwjmfYc4gGWbmQJTo2wfQ3z3OrIRzoI6TeEpAaNOQgbg9Y6orbnXY5o+mobw3hGA006OPf3TQTdubUbJgt4Tfj+96uW/7LC7NvwmEHVwt1qfepruuC1CV3q2H8T8TkEnQz3Gakbv6MwByF2Nxczb3D9ugtGBMDCY/0aGhzV58/Jz7DOEHTEdqukrm2HcaDe1I8hFEHECDaIOl+ub9B0eqO8xx5HnrWGGBxB58vr0e6im/cqyqxJUUGIYDBZ2qig0C8/nFRx+EnlR18GNcvMbCxY9O/tkz886OKgIWTIQ2sY16Wr5V3xdIoEnvy1mvaWs5hIam5mJd+GlyxS10EzbAsMjmhVV+7s1X0qewOKfZl5VEGXu2JPakkxdrsYYisIxyek0RfkjT/PAUq/fFze2AsaWX0LroZQDQ7OqMG2BdqGeVF8Z2sB0UZ2IDEhCbHc9eniygn5lZcVj/9TGnlE/tmDICZoVE4q6FqWEjSar7/zuxpVwbhNDTeGoEUMB7FGSwlhs3LMRRiLNBZx4upRjoYxF4mqvRtYTtQ3lGFuPUosaMAImhfEPLiSInRyY9DP1ImnLwkqhJMaoYu94xxMeSjOgch008limxA0l7I/Vwx/ooTI7I6KLBFlVsm1dMszQrk25SYOpW+MMz84jCs4GuanMX+hi2k2RozLZCNFxEKvNqTCvH6AkKQkGVQ4j83anbZbXv09BOsbdp28E4Lu1POJJazG8uOx+xwvXlbt1V+ApENJ+9sUN10MccJJ81qFrWswm6UqlJ+DZ0JYggrM+foO7ObwCtA0ZmORw1NZw/d9z+kosaO+pM7qT6SmNkXtaxUVL+Hofwd2sELNk4+qdPoRFJGHKASbh+9GIWNoYdoxaKrWv7ClCV2o4vwNKm7+jQKUUavgduRAEfkBB5fLn2qYWoD+AsL/NBuH8aguumcLFA6Bb8S8xQdwolegXiADqA09q/IDtwi25Zl8yDMSErukk8XILuQ5xFwj0HnBUa2456PwR+IEnM30KE4zdZRZyHaioMWMLpF/9a0Ku97j0M054DHIzr1fV37k3yjiGMgG9caD3ijPEA3Q+7QWMLkHwl28aKafNWsCwxRWO870Ibx/kN6oriPbrGcNRschtI4VR9SyzmUIoAKhBA/KoKGkTtBnKx8F5qlFIsBdxMIBeJpV5hBsjM8QXg25ceoEZDBBWlsc6mHagfMfBecl2CA8u3Wb2MAAXOFinIcegvFRpQ8/Hqg953U2xzbHS+EnYY4lfDFCSsjoEgNiU9jYtdZ/q/KWAB2oBiDjvoooo3V9ihd+Q3F2K6c6fsssk4MlbK6lb2NmQzSujZMJRcHdah36nnqePIH4Q+dPdcBvBfa8AKGb5rBPAWoY2VywdrHCpX/Ae69KgbDMgZgNyoAZoPpYA+TstvFe8dPqOPZx5Q8cR9qB8G3b8XxA5wCcA2wCxbVcsVTFS/6Bqdm9CWtpAGIn28w2d5vWnzmIncRMegbUtrTcqQHaDnaGz0k4OqXmI9eq54VjzpfOA3QGIOvSe1kfErNTrH3LALHri3PUZoAMJLli4PerUlyn2HIuo2Ibu64J3+bw6J4TQt0+5cc4y0NCnV1ZrTo6rDHwPtnt6l3shxGdQKKzkjBmprT0EOokPcawW9R144/lNRGVbCOmWCYSIRbaanYdVJanmDj7PcsBrJr0GocmXde3CwNHj8sNQNx09rBKJx6FDoHeGHN2ai0LMtN3avX9X0JvZbw7sEjIm3p2bbHFJBcCrnvTFmV7fz1jT7bYwMXcU/NgJqNxoALiFymAXUcT+jbmcaAaTidKgCVU995SfBIYj+zc43TveJ6jzdRtEjUYZiamnZbBz6r/yb/iiuWGJC1iCvfPEAoKwGxRrusLbgOnI945NgOVs1en4CxjAphlTn4ISM7YqPKq7WCTZxVf2dISpDcfiyDjrQEY9EmhXeWlV6vllV1sgyR9qvtSAdAyeyd6AC3WuI5F9Dn/LHe24Jnnz6Kyn1+VigHkSM1tDNe1DGo1VVquAxg/GiWlGeZAPJbO4Xduid07Lxx2c22NF6YpYa1tJcAQoc8ezjTqbZRd5TAYFsMENmRMscgeMWBHRhyNuDHWyM5WkyQv/bjsUh17Z26QSrYGBSTwP4p7574jEEWMFMXU7NultpFfWdJm5Oy9H484DIbFMNmQ/bjIbwK1v3DymRlqttAZladiuMfZk7KoyhLi4kIHONPcrUJzXtkstskmVq1faC4oUyK3s/mlhSR9qcPYFsUze1JQTnoOAT8szE894zAYFjuNKFl3/Ng1zszWDtszD96u3i3X8Fx0u5mEoqzy8WE3pdx8EzaIungyCrG/ENVz3yuMKWNOwpilYnGWvCU3D9vPwci8NIUjy295/U9cH6CVWGKLfCxts+IlVS177HaHwS6Sdk5z0qRXCQsxOQD5ZEQJp2y+Z5VaNv4OzRZIqAFoXkzmZdlXFKia38RHsQ1KpsewKyq0EvLtVPVuN0DhsSRacdaS0g41je1VaehBnIowa+lfkHWMO2+OEEz/vk+p7QzXDE5t+5BWI5qloQYmBoBmVwu7ooyrAxPtxln61Pq+H8pvWu6+rEQYdUwFoGJSRj5HmBMFuVXUlYQ2jugsaqT4OFKm9pryk4eoLzIPeYcGyMDRuorkLNR4tSNa9uBXlAssRJ8hiR4DxUyqZJoytXgaoBrICe7rllvWnBV0K7d8rYprvo4uyRaRplX7SMCVyHm5AcfL3bjZlOnYOT8AImpswAyMPZu5WJ9tPcJAx4Hvq/M/T7HzGTTIXQDJ2QdJ8jjwuLPZAeSFK06S9h0gQLVFQk7GAe1ipAsrX6DShu186byO4MqXGFO9AQZRozWAFtgte+dVeg7TNvqckGo6s0st/9yhppolYXz2pUYAq5KC2jlGbjg7yZwD0FBC3kzJg4usWSMgizy3OPv0LGuHR0uLnZGtvFxxzxouLwsVZrjh4LIGJiGOJBbFqyeVO71f+SMHlLVbJvdQC2oJgMzO7PpiXyyHAL4NqbEzgIBwrrwJYOPVDNBfAfFywE4CtoRkpwDsU/OYQvpl2NJVXJV5Pn9W7G5nH3USDMUig8eqgMpRziqT1TQsBjoAqM8x7zzAGjj+J8DGhDpQe/S0m+0si7YoHwOa732ME4MYC6j1+6eDZp/jAqq5Qo4Rn9ZukabYTW7c9GT/cyRmG80u/xfg7MmNvgNtDylpM4fz07HPTjar/vb/gWnQn93+F1XdTL7k8ES+AAAAAElFTkSuQmCC";
      decimals = 8;
      fee = ?#Fixed(10000);
      minting_account = ?{
        owner = _owner;
        subaccount = null;
      };
      max_supply = ?100_000_000_00000000;
      min_burn_amount = null;
      max_memo = ?64;
      advanced_settings = null;
      metadata = null;
      fee_collector = ?{
        owner = _owner;
        subaccount = null;
    };
      transaction_window = null;
      permitted_drift = null;
      max_accounts = ?100000000;
      settle_to_accounts = ?99999000;
    };

    let default_icrc2_args : ICRC2.InitArgs = {
      max_approvals_per_account = ?10000;
      max_allowance = ?#TotalSupply;
      fee = ?#ICRC1;
      advanced_settings = null;
      max_approvals = ?10000000;
      settle_to_approvals = ?9990000;
    };

    let default_icrc3_args : ICRC3.InitArgs = ?{
      maxActiveRecords = 3000;
      settleToRecords = 2000;
      maxRecordsInArchiveInstance = 100000000;
      maxArchivePages = 62500;
      archiveIndexType = #Stable;
      maxRecordsToArchive = 8000;
      archiveCycles = 20_000_000_000_000;
      archiveControllers = null; //??[put cycle ops prinicpal here];
      supportedBlocks = [
        {
          block_type = "1xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2approve"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1mint"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        }
      ];
    };

    let default_icrc4_args : ICRC4.InitArgs = {
      max_balances = ?200;
      max_transfers = ?200;
      fee = ?#ICRC1;
    };

    let icrc1_args : ICRC1.InitArgs = switch(args){
      case(null) default_icrc1_args;
      case(?args){
        switch(args.icrc1){
          case(null) default_icrc1_args;
          case(?val){
            {
              val with minting_account = switch(
                val.minting_account){
                  case(?val) ?val;
                  case(null) {?{
                    owner = _owner;
                    subaccount = null;
                  }};
                };
            };
          };
        };
      };
    };

    let icrc2_args : ICRC2.InitArgs = switch(args){
      case(null) default_icrc2_args;
      case(?args){
        switch(args.icrc2){
          case(null) default_icrc2_args;
          case(?val) val;
        };
      };
    };


    let icrc3_args : ICRC3.InitArgs = switch(args){
      case(null) default_icrc3_args;
      case(?args){
        switch(args.icrc3){
          case(null) default_icrc3_args;
          case(?val) ?val;
        };
      };
    };

    let icrc4_args : ICRC4.InitArgs = switch(args){
      case(null) default_icrc4_args;
      case(?args){
        switch(args.icrc4){
          case(null) default_icrc4_args;
          case(?val) val;
        };
      };
    };

    stable let icrc1_migration_state = ICRC1.init(ICRC1.initialState(), #v0_1_0(#id),?icrc1_args, _owner);
    stable let icrc2_migration_state = ICRC2.init(ICRC2.initialState(), #v0_1_0(#id),?icrc2_args, _owner);
    stable let icrc4_migration_state = ICRC4.init(ICRC4.initialState(), #v0_1_0(#id),?icrc4_args, _owner);
    stable let icrc3_migration_state = ICRC3.init(ICRC3.initialState(), #v0_1_0(#id), icrc3_args, _owner);
    stable let cert_store : CertTree.Store = CertTree.newStore();
    let ct = CertTree.Ops(cert_store);


    stable var owner = _owner;

    let #v0_1_0(#data(icrc1_state_current)) = icrc1_migration_state;

    private var _icrc1 : ?ICRC1.ICRC1 = null;

    private func get_icrc1_state() : ICRC1.CurrentState {
      return icrc1_state_current;
    };

    private func get_icrc1_environment() : ICRC1.Environment {
    {
      get_time = null;
      get_fee = null;
      add_ledger_transaction = ?icrc3().add_record;
      can_transfer = null; //set to a function to intercept and add validation logic for transfers
    };
  };

    func icrc1() : ICRC1.ICRC1 {
    switch(_icrc1){
      case(null){
        let initclass : ICRC1.ICRC1 = ICRC1.ICRC1(?icrc1_migration_state, Principal.fromActor(this), get_icrc1_environment());
        ignore initclass.register_supported_standards({
          name = "ICRC-3";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-3/"
        });
        ignore initclass.register_supported_standards({
          name = "ICRC-10";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-10/"
        });
        _icrc1 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;

  private var _icrc2 : ?ICRC2.ICRC2 = null;

  private func get_icrc2_state() : ICRC2.CurrentState {
    return icrc2_state_current;
  };

  private func get_icrc2_environment() : ICRC2.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc2() : ICRC2.ICRC2 {
    switch(_icrc2){
      case(null){
        let initclass : ICRC2.ICRC2 = ICRC2.ICRC2(?icrc2_migration_state, Principal.fromActor(this), get_icrc2_environment());
        _icrc2 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc4_state_current)) = icrc4_migration_state;

  private var _icrc4 : ?ICRC4.ICRC4 = null;

  private func get_icrc4_state() : ICRC4.CurrentState {
    return icrc4_state_current;
  };

  private func get_icrc4_environment() : ICRC4.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc4() : ICRC4.ICRC4 {
    switch(_icrc4){
      case(null){
        let initclass : ICRC4.ICRC4 = ICRC4.ICRC4(?icrc4_migration_state, Principal.fromActor(this), get_icrc4_environment());
        _icrc4 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc3_state_current)) = icrc3_migration_state;

  private var _icrc3 : ?ICRC3.ICRC3 = null;

  private func get_icrc3_state() : ICRC3.CurrentState {
    return icrc3_state_current;
  };

  func get_state() : ICRC3.CurrentState{
    return icrc3_state_current;
  };

  private func get_icrc3_environment() : ICRC3.Environment {
    ?{
      updated_certification = ?updated_certification;
      get_certificate_store = ?get_certificate_store;
    };
  };

  func ensure_block_types(icrc3Class: ICRC3.ICRC3) : () {
    let supportedBlocks = Buffer.fromIter<ICRC3.BlockType>(icrc3Class.supported_block_types().vals());

    let blockequal = func(a : {block_type: Text}, b : {block_type: Text}) : Bool {
      a.block_type == b.block_type;
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2approve";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2approve"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1mint";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1mint"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };



    icrc3Class.update_supported_blocks(Buffer.toArray(supportedBlocks));
  };

  func icrc3() : ICRC3.ICRC3 {
    switch(_icrc3){
      case(null){
        let initclass : ICRC3.ICRC3 = ICRC3.ICRC3(?icrc3_migration_state, Principal.fromActor(this), get_icrc3_environment());
        _icrc3 := ?initclass;
        ensure_block_types(initclass);

        initclass;
      };
      case(?val) val;
    };
  };

  private func updated_certification(cert: Blob, lastIndex: Nat) : Bool{

    // D.print("updating the certification " # debug_show(CertifiedData.getCertificate(), ct.treeHash()));
    ct.setCertifiedData();
    // D.print("did the certification " # debug_show(CertifiedData.getCertificate()));
    return true;
  };

  private func get_certificate_store() : CertTree.Store {
    // D.print("returning cert store " # debug_show(cert_store));
    return cert_store;
  };

  /// Functions for the ICRC1 token standard
  public shared query func icrc1_name() : async Text {
      icrc1().name();
  };

  public shared query func icrc1_symbol() : async Text {
      icrc1().symbol();
  };

  public shared query func icrc1_decimals() : async Nat8 {
      icrc1().decimals();
  };

  public shared query func icrc1_fee() : async ICRC1.Balance {
      icrc1().fee();
  };

  public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
      icrc1().metadata()
  };

  public shared query func icrc1_total_supply() : async ICRC1.Balance {
      icrc1().total_supply();
  };

  public shared query func icrc1_minting_account() : async ?ICRC1.Account {
      ?icrc1().minting_account();
  };

  public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
      icrc1().balance_of(args);
  };

  public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared query func icrc10_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
      switch(await* icrc1().transfer_tokens(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
      if(caller != owner){ D.trap("Unauthorized")};

      switch( await* icrc1().mint_tokens(caller, args)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

   public query ({ caller }) func icrc2_allowance(args: ICRC2.AllowanceArgs) : async ICRC2.Allowance {
      return icrc2().allowance(args.spender, args.account, false);
    };

  public shared ({ caller }) func icrc2_approve(args : ICRC2.ApproveArgs) : async ICRC2.ApproveResponse {
      switch(await*  icrc2().approve_transfers(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func icrc2_transfer_from(args : ICRC2.TransferFromArgs) : async ICRC2.TransferFromResponse {
      switch(await* icrc2().transfer_tokens_from(caller, args, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public query func icrc3_get_blocks(args: ICRC3.GetBlocksArgs) : async ICRC3.GetBlocksResult{
    return icrc3().get_blocks(args);
  };

  public query func icrc3_get_archives(args: ICRC3.GetArchivesArgs) : async ICRC3.GetArchivesResult{
    return icrc3().get_archives(args);
  };

  public query func icrc3_get_tip_certificate() : async ?ICRC3.DataCertificate {
    return icrc3().get_tip_certificate();
  };

  public query func icrc3_supported_block_types() : async [ICRC3.BlockType] {
    return icrc3().supported_block_types();
  };

  public query func get_tip() : async ICRC3.Tip {
    return icrc3().get_tip();
  };

  public shared ({ caller }) func icrc4_transfer_batch(args: ICRC4.TransferBatchArgs) : async ICRC4.TransferBatchResults {
      switch(await* icrc4().transfer_batch_tokens(caller, args, null, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) err;
        case(#err(#awaited(err))) err;
      };
  };

  public shared query func icrc4_balance_of_batch(request : ICRC4.BalanceQueryArgs) : async ICRC4.BalanceQueryResult {
      icrc4().balance_of_batch(request);
  };

  public shared query func icrc4_maximum_update_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_transfers;
  };

  public shared query func icrc4_maximum_query_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_balances;
  };

  public shared ({ caller }) func admin_update_owner(new_owner : Principal) : async Bool {
    if(caller != owner){ D.trap("Unauthorized")};
    owner := new_owner;
    return true;
  };

  public shared ({ caller }) func admin_update_icrc1(requests : [ICRC1.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc1().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc2(requests : [ICRC2.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc2().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc4(requests : [ICRC4.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc4().update_ledger_info(requests);
  };

  // Deposit cycles into this canister.
  public shared func deposit_cycles() : async () {
      let amount = ExperimentalCycles.available();
      let accepted = ExperimentalCycles.accept<system>(amount);
      assert (accepted == amount);
  };
};