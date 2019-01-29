unit Unit5;

interface

uses
  System.SysUtils, System.Classes, FMX.Controls, FMX.StdCtrls, unit2;

type

  TBus = class(TPanel)
  private
    FBusIsGood: boolean;
    FEarth: boolean;
    FLowPower: boolean;


    FPinBus: integer;
    FPinEarth: integer;
    FPinLowPower: integer;

    procedure SetPinBus(const Value: integer);
    procedure SetPinEarth(const Value: integer);
    procedure SetPinLowPower(const Value: integer);
    procedure SetBusStatus(const Value: Boolean);
    procedure SetEarthStatus(const Value: Boolean);
    procedure SetLowPowerStatus(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    property PinBus: integer read FPinBus write SetPinBus;
    property PinEarth: integer read FPinEarth write SetPinEarth;
    property PinLowPower: integer read FPinLowPower write SetPinLowPower;
  published
    property BusIsGood: Boolean read FBusIsGood write SetBusStatus;  { Состояние линии }
    property Earth: Boolean read FEarth write SetEarthStatus;
    property LowPower: Boolean read FLowPower write SetLowPowerStatus;
  end;

implementation

constructor TBus.Create(AOwner: TComponent);
begin
  inherited;
  StyleLookup := 'BusStyle';
  NeedStyleLookup;
  BusIsGood:=true;
  Earth:=true;
  LowPower:=true;
end;

destructor TBus.Destroy;
begin
  inherited;
end;

procedure TBus.SetBusStatus(const Value: Boolean);
begin
  if FBusIsGood <> Value then
  begin
    FBusIsGood := Value;
    ApplyTriggerEffect(Self, 'BusIsGood');
    StartTriggerAnimation(Self, 'BusIsGood');
  end;
end;

procedure TBus.SetEarthStatus(const Value: Boolean);
begin
  if FEarth <> Value then
  begin
    FEarth := Value;
    ApplyTriggerEffect(Self, 'Earth');
    StartTriggerAnimation(Self, 'Earth');
  end;
end;

procedure TBus.SetLowPowerStatus(const Value: Boolean);
begin
  if FLowPower <> Value then
  begin
    FLowPower := Value;
    ApplyTriggerEffect(Self, 'LowPower');
    StartTriggerAnimation(Self, 'LowPower');
  end;
end;

procedure TBus.SetPinBus(const Value: integer);
begin
  FPinBus := Value;
end;

procedure TBus.SetPinEarth(const Value: integer);
begin
  FPinEarth := Value;
end;

procedure TBus.SetPinLowPower(const Value: integer);
begin
  FPinLowPower := Value;
end;

end.
