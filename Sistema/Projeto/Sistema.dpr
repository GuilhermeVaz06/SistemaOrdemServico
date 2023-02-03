program Sistema;

uses
  Vcl.Forms,
  MenuPrincipal in '..\Tela\MenuPrincipal.pas' {FMenuPrincipal},
  UFuncao in '..\Units\UFuncao.pas',
  Pais in '..\Tela\Pais.pas' {FPais},
  UConexao in '..\Units\UConexao.pas',
  DMEstado in '..\Data Module\DMEstado.pas' {FDMEstado: TDataModule},
  DMPais in '..\Data Module\DMPais.pas' {FDMPais: TDataModule},
  Estado in '..\Tela\Estado.pas' {FEstado};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TFMenuPrincipal, FMenuPrincipal);
  Application.CreateForm(TFDMEstado, FDMEstado);
  Application.CreateForm(TFDMPais, FDMPais);
  Application.Run;
end.
