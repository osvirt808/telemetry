unit Unit4;

interface

uses
  System.SysUtils, System.Classes, FMX.Controls, FMX.StdCtrls, unit2;

type

  TActStatus = (F35In, F6In, F6OutOn, F6OutOff, F6ConnectA, F6ConnectB);

  TMyFider = class(TPanel)
  private
    FIsOn: Boolean;
    FLineIsGood: boolean;
    FActivity: TActStatus;

    FPinKey: integer;
    FPinAlarm: integer;
    FLine: byte;
    FText: ShortString;
    FLabel: ShortString;
    FSection: byte;

    procedure SetLine(Val: byte);
    procedure SetText(Val: ShortString);

    procedure SetOnOff(Val: Boolean);
    procedure SetLineStatus(Val: Boolean);
    procedure SetPinKey(const Value: integer);
    procedure SetPinAlarm(const Value: integer);
    procedure SetLabel(const Value: ShortString);
    procedure SetActivity(const Value: TActStatus);
    procedure SetSection(const Value: byte);

  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    property Text: ShortString read FText Write SetText;
    property lLabel: ShortString read FLabel Write SetLabel;
    property PinKey: integer read FPinKey write SetPinKey;
    property PinAlarm: integer read FPinAlarm write SetPinAlarm;
    property Line: byte read FLine write SetLine;
    property Activity: TActStatus read FActivity write SetActivity;  { Состояние выключателя }
    property Section: byte read FSection write SetSection;
  published
    property IsOn: Boolean read FIsOn write SetOnOff;  { Состояние выключателя }
    property LineIsGood: Boolean read FLineIsGood write SetLineStatus;  { Состояние линии }
  end;


implementation

{ TMyFider }

constructor TMyFider.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TMyFider.Destroy;
begin
  inherited;
end;

procedure TMyFider.SetLabel(const Value: ShortString);
begin
  FLabel := Value;
  StylesData['label.text'] := Value;
end;

procedure TMyFider.SetLine(Val: byte);
begin
  FLine := Val;
  lLabel := inttostr(Val);
end;

procedure TMyFider.SetPinAlarm(const Value: integer);
begin
  FPinAlarm := Value;
end;

procedure TMyFider.SetPinKey(const Value: integer);
begin
  FPinKey := Value;
end;

procedure TMyFider.SetText(Val: ShortString);
begin
  FText := Val;
  StylesData['text.text'] := Val;
end;

procedure TMyFider.SetActivity(const Value: TActStatus);
begin
  FActivity := Value;
  case Value of
    F6OutOn:  begin
                StyleLookup := 'fider6OutOn';
                NeedStyleLookup;
              end;
    F6OutOff: begin
                StyleLookup := 'fider6OutOff';
                NeedStyleLookup;
              end;
    F6In:     begin
                StyleLookup := 'fider6In';
                NeedStyleLookup;
              end;
    F35In:     begin
                StyleLookup := 'fider35In';
                NeedStyleLookup;
              end;
  end;
end;

procedure TMyFider.SetLineStatus(Val: Boolean);
begin
//  if FIsOn <> Val then
  begin
    FIsOn := Val;
    ApplyTriggerEffect(Self, 'IsOn');
    StartTriggerAnimation(Self, 'IsOn');
  end;
end;

procedure TMyFider.SetOnOff(Val: Boolean);
begin
//  if FLineIsGood <> Val then
  begin
    FLineIsGood := Val;
    ApplyTriggerEffect(Self, 'LineIsGood');
    StartTriggerAnimation(Self, 'LineIsGood');
  end;
end;

procedure TMyFider.SetSection(const Value: byte);
begin
  FSection := Value;
  case Activity of
    F35In: text := 'Ввод 35кВ №' + inttostr(Value);
    F6In: text := 'Ввод 6кВ №' + inttostr(Value);
    F6OutOn: text := '6-' + inttostr(line) + '-'+ inttostr(Value);
    F6OutOff: text := 'Резерв';

    F6ConnectA: ;
    F6ConnectB: ;
  end;
end;

end.
