unit Unit7;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Layouts;

type

  TShield = class(TPanel)
  private
    FBusIsGood: boolean;
    FEarth: boolean;
    FLowPower: boolean;
    FAhtung: boolean;
    FPinAhtung: integer;

    procedure SetBusStatus(const Value: Boolean);
    procedure SetEarthStatus(const Value: Boolean);
    procedure SetLowPowerStatus(const Value: Boolean);
    procedure SetAhtung(const Value: Boolean);
    procedure SetPinAhtung(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    property PinAhtung: integer read FPinAhtung write SetPinAhtung;


  published
    property BusIsGood: Boolean read FBusIsGood write SetBusStatus;  { Состояние линии }
    property Earth: Boolean read FEarth write SetEarthStatus;
    property LowPower: Boolean read FLowPower write SetLowPowerStatus;
    property Ahtung: Boolean read FAhtung write SetAhtung;
  end;

implementation

constructor TShield.Create(AOwner: TComponent);
begin
  inherited;
  StyleLookup := 'MainShield';
  NeedStyleLookup;
  Earth := true;
  Ahtung := true;
  LowPower := true;
  BusIsGood := true;
  Align := TAlignLayout.Scale;
end;

destructor TShield.Destroy;
begin
  inherited;
end;

procedure TShield.SetAhtung(const Value: Boolean);
begin
  if FAhtung <> Value then
  begin
    FAhtung := Value;
    ApplyTriggerEffect(Self, 'Ahtung');
    StartTriggerAnimation(Self, 'Ahtung');
  end;
end;

procedure TShield.SetBusStatus(const Value: Boolean);
begin
  if FBusIsGood <> Value then
  begin
    FBusIsGood := Value;
    ApplyTriggerEffect(Self, 'BusIsGood');
    StartTriggerAnimation(Self, 'BusIsGood');
  end;
end;

procedure TShield.SetEarthStatus(const Value: Boolean);
begin
  if FEarth <> Value then
  begin
    FEarth := Value;
    ApplyTriggerEffect(Self, 'Earth');
    StartTriggerAnimation(Self, 'Earth');
  end;
end;

procedure TShield.SetLowPowerStatus(const Value: Boolean);
begin
  if FLowPower <> Value then
  begin
    FLowPower := Value;
    ApplyTriggerEffect(Self, 'LowPower');
    StartTriggerAnimation(Self, 'LowPower');
  end;
end;

procedure TShield.SetPinAhtung(const Value: integer);
begin
  FPinAhtung := Value;
end;

end.
