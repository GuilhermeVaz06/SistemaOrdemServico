program API;

uses
  Vcl.Forms,
  Model.Cidade in '..\Units\Models\Model.Cidade.pas',
  Model.Connection in '..\Units\Models\Model.Connection.pas',
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
  Model.Pessoa.Contato in '..\Units\Models\Model.Pessoa.Contato.pas',
  Model.Pessoa.OutroDocumento in '..\Units\Models\Model.Pessoa.OutroDocumento.pas',
  Controller.Pessoa.OutroDocumento in '..\Units\Controllers\Controller.Pessoa.OutroDocumento.pas',
  Controller.Pessoa in '..\Units\Controllers\Controller.Pessoa.pas',
  Controller.Pessoa.Endereco in '..\Units\Controllers\Controller.Pessoa.Endereco.pas',
  Model.Pessoa.Endereco in '..\Units\Models\Model.Pessoa.Endereco.pas',
  Controller.Pessoa.Contato in '..\Units\Controllers\Controller.Pessoa.Contato.pas',
  Model.Funcao in '..\Units\Models\Model.Funcao.pas',
  Controller.Funcao in '..\Units\Controllers\Controller.Funcao.pas',
  Model.Grupo in '..\Units\Models\Model.Grupo.pas',
  Controller.Grupo in '..\Units\Controllers\Controller.Grupo.pas',
  Model.OrdemServico in '..\Units\Models\Model.OrdemServico.pas',
  Controller.OrdemServico in '..\Units\Controllers\Controller.OrdemServico.pas',
  Model.OrdemServico.Item in '..\Units\Models\Model.OrdemServico.Item.pas',
  Controller.OrdemServico.Item in '..\Units\Controllers\Controller.OrdemServico.Item.pas',
  Model.OrdemServico.Produto in '..\Units\Models\Model.OrdemServico.Produto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
