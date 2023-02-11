program API;

uses
  Vcl.Forms,
  Model.Cidade in '..\Units\Models\Model.Cidade.pas',
  Model.Connection in '..\Units\Models\Model.Connection.pas',
  Model.Contato in '..\Units\Models\Model.Contato.pas',
  Model.Endereco in '..\Units\Models\Model.Endereco.pas',
  Model.Estado in '..\Units\Models\Model.Estado.pas',
  Model.Pais in '..\Units\Models\Model.Pais.pas',
  Model.Pessoa in '..\Units\Models\Model.Pessoa.pas',
  Model.Sessao in '..\Units\Models\Model.Sessao.pas',
  Model.TipoDocumento in '..\Units\Models\Model.TipoDocumento.pas',
  Model.TipoEndereco in '..\Units\Models\Model.TipoEndereco.pas',
  Model.TipoPessoa in '..\Units\Models\Model.TipoPessoa.pas',
  Principal in '..\Tela\Principal.pas' {FPrincipal},
  Controller.Pais in '..\Units\Controllers\Controller.Pais.pas',
  UFuncao in '..\Units\UFuncao.pas',
  Controller.Estado in '..\Units\Controllers\Controller.Estado.pas',
  Controller.Cidade in '..\Units\Controllers\Controller.Cidade.pas',
  Controller.TipoDocumento in '..\Units\Controllers\Controller.TipoDocumento.pas',
  Controller.TipoEndereco in '..\Units\Controllers\Controller.TipoEndereco.pas',
  Controller.Pessoa in '..\Units\Controllers\Controller.Pessoa.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
