program Sistema;

uses
  Vcl.Forms,
  MenuPrincipal in '..\Tela\MenuPrincipal.pas' {FMenuPrincipal},
  UFuncao in '..\Units\UFuncao.pas',
  Pais in '..\Tela\Pais.pas' {FPais},
  UConexao in '..\Units\UConexao.pas',
  DMEstado in '..\Data Module\DMEstado.pas' {FDMEstado: TDataModule},
  Estado in '..\Tela\Estado.pas' {FEstado},
  DMCidade in '..\Data Module\DMCidade.pas' {FDMCidade: TDataModule},
  Cidade in '..\Tela\Cidade.pas' {FCidade},
  DMTipoDocumento in '..\Data Module\DMTipoDocumento.pas' {FDMTipoDocumento: TDataModule},
  TipoDocumento in '..\Tela\TipoDocumento.pas' {FTipoDocumento},
  DMTipoEndereco in '..\Data Module\DMTipoEndereco.pas' {FDMTipoEndereco: TDataModule},
  TipoEndereco in '..\Tela\TipoEndereco.pas' {FTipoEndereco},
  OutroDocumento in '..\Tela\OutroDocumento.pas' {FOutroDocumento},
  DMPessoa in '..\Data Module\DMPessoa.pas' {FDMPessoa: TDataModule},
  Pessoa in '..\Tela\Pessoa.pas' {FPessoa},
  Endereco in '..\Tela\Endereco.pas' {FEndereco},
  Contato in '..\Tela\Contato.pas' {FContato},
  DMPais in '..\Data Module\DMPais.pas' {FDMPais: TDataModule},
  DMFuncao in '..\Data Module\DMFuncao.pas' {FDMFuncao: TDataModule},
  Funcao in '..\Tela\Funcao.pas' {FFuncao},
  DMGrupo in '..\Data Module\DMGrupo.pas' {FDMGrupo: TDataModule},
  Grupo in '..\Tela\Grupo.pas' {FGrupo},
  OrdemServico in '..\Tela\OrdemServico.pas' {FOrdemServico},
  DMOrdemServico in '..\Data Module\DMOrdemServico.pas' {FDMOrdemServico: TDataModule};

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
  Application.CreateForm(TFOutroDocumento, FOutroDocumento);
  Application.CreateForm(TFDMPessoa, FDMPessoa);
  Application.CreateForm(TFDMPais, FDMPais);
  Application.CreateForm(TFDMFuncao, FDMFuncao);
  Application.CreateForm(TFDMGrupo, FDMGrupo);
  Application.CreateForm(TFDMOrdemServico, FDMOrdemServico);
  Application.Run;
end.
