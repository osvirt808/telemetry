program Project3;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas',
  Unit5 in 'Unit5.pas',
  Unit2 in 'Unit2.pas' {Form2},
  Unit7 in 'Unit7.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
