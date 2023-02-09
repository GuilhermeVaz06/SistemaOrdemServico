program Sistema;

uses
  Vcl.Forms,
  MenuPrincipal in '..\Tela\MenuPrincipal.pas' {FMenuPrincipal},
  UFuncao in '..\Units\UFuncao.pas',
  Pais in '..\Tela\Pais.pas' {FPais},
  UConexao in '..\Units\UConexao.pas',
  DMEstado in '..\Data Module\DMEstado.pas' {FDMEstado: TDataModule},
  DMPais in '..\Data Module\DMPais.pas' {FDMPais: TDataModule},
  Estado in '..\Tela\Estado.pas' {FEstado},
  DMCidade in '..\Data Module\DMCidade.pas' {FDMCidade: TDataModule},
  Cidade in '..\Tela\Cidade.pas' {FCidade},
  DMTipoDocumento in '..\Data Module\DMTipoDocumento.pas' {FDMTipoDocumento: TDataModule},
  TipoDocumento in '..\Tela\TipoDocumento.pas' {FTipoDocumento},
  DMTipoEndereco in '..\Data Module\DMTipoEndereco.pas' {FDMTipoEndereco: TDataModule},
  TipoEndereco in '..\Tela\TipoEndereco.pas' {FTipoEndereco};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TFMenuPrincipal, FMenuPrincipal);
  Application.CreateForm(TFDMEstado, FDMEstado);
  Application.CreateForm(TFDMPais, FDMPais);
  Application.CreateForm(TFDMCidade, FDMCidade);
  Application.CreateForm(TFDMTipoDocumento, FDMTipoDocumento);
  Application.CreateForm(TFDMTipoEndereco, FDMTipoEndereco);
  Application.CreateForm(TFTipoEndereco, FTipoEndereco);
  Application.Run;
end.
