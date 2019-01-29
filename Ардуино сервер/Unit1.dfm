object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Server'
  ClientHeight = 493
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 40
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Memo1: TMemo
    Left = 8
    Top = 72
    Width = 541
    Height = 413
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ServManager: TTetheringManager
    OnPairedFromLocal = ServManagerPairedFromLocal
    OnPairedToRemote = ServManagerPairedToRemote
    OnRequestManagerPassword = ServManagerRequestManagerPassword
    OnEndAutoConnect = ServManagerEndAutoConnect
    Password = '123456'
    Text = 'ServManager'
    AllowedAdapters = 'Network'
    Left = 248
    Top = 24
  end
  object ServAppProfile: TTetheringAppProfile
    Manager = ServManager
    Text = 'ServAppProfile'
    Group = '123'
    Actions = <
      item
        Name = 'Action1'
        IsPublic = True
        Action = Action1
        NotifyUpdates = False
      end>
    Resources = <
      item
        Name = 'ArduinoStatus'
        IsPublic = True
      end>
    Left = 336
    Top = 24
  end
  object ActionList1: TActionList
    Left = 168
    Top = 24
    object Action1: TAction
      Caption = 'Action1'
      OnExecute = Action1Execute
    end
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM3'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Timeouts.ReadInterval = 1000
    StoredProps = [spBasic, spBuffer, spTimeouts]
    TriggersOnRxChar = False
    Left = 336
    Top = 88
  end
  object ComDataPacket1: TComDataPacket
    ComPort = ComPort1
    StartString = '['
    StopString = ']'
    OnPacket = ComDataPacket1Packet
    Left = 264
    Top = 88
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 184
    Top = 88
  end
end
