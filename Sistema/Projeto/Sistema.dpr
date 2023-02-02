program Sistema;

uses
  Vcl.Forms,
  MenuPrincipal in '..\Tela\MenuPrincipal.pas' {FMenuPrincipal},
  UFuncao in '..\Units\UFuncao.pas',
  Pais in '..\Tela\Pais.pas' {FPais},
  DMPais in '..\Data Module\DMPais.pas' {FDMPais: TDataModule},
  UConexao in '..\Units\UConexao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TFMenuPrincipal, FMenuPrincipal);
  Application.CreateForm(TFDMPais, FDMPais);
  Application.Run;
end.
