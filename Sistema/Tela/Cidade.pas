unit Cidade;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows;

type
  TFCidade = class(TForm)
    Panel1: TPanel;
    PDados: TPanel;
    BFechar: TSpeedButton;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    BInativar: TSpeedButton;
    BAlterar: TSpeedButton;
    BCadastrar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    EPais: TDBEdit;
    Label3: TLabel;
    ECodigo: TDBEdit;
    ECodigoIbge: TDBEdit;
    DBNavigator1: TDBNavigator;
    PGrid: TPanel;
    Panel2: TPanel;
    CBMostrarInativo: TCheckBox;
    Panel3: TPanel;
    BConsultar: TSpeedButton;
    GDados: TDBGrid;
    CBAtivo: TDBCheckBox;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ECadastradoPor: TDBEdit;
    EAlteradoPor: TDBEdit;
    EDataCadastro: TDBEdit;
    EDataAlteracao: TDBEdit;
    ELocalizarCodigoIBGE: TEdit;
    Label9: TLabel;
    ELocalizarNome: TEdit;
    Label10: TLabel;
    Estado: TLabel;
    DBEstado: TDBEdit;
    DBEdit2: TDBEdit;
    Label11: TLabel;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    procedure BFecharClick(Sender: TObject);
    procedure BCadastrarClick(Sender: TObject);
    procedure BAlterarClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure BConfirmarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure BConsultarClick(Sender: TObject);
    procedure BInativarClick(Sender: TObject);
    procedure GDadosTitleClick(Column: TColumn);
    procedure CBMostrarInativoClick(Sender: TObject);
    procedure DBEstadoDblClick(Sender: TObject);
    procedure GDadosDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBEstadoExit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FCidade: TFCidade;

implementation

uses UFuncao, DMCidade, DMEstado, Estado;

{$R *.dfm}

procedure TFCidade.BAlterarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMCidade.TCidade.Edit;
end;

procedure TFCidade.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMCidade.TCidade.Append;
end;

procedure TFCidade.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMCidade.TCidade.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFCidade.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;

  if (validarCampos) then
  begin
    if (FDMCidade.TCidade.State = dsInsert) then
    begin
      resposta := FDMCidade.cadastrarCidade;
    end
    else if (FDMCidade.TCidade.State = dsEdit) then
    begin
      resposta := FDMCidade.alterarCidade;
    end;

    if (resposta) then
    begin
      FDMCidade.TCidade.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFCidade.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMCidade.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFCidade.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFCidade.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if (UsuarioAdmnistrador) and
     (confirmar('Realmente deseja inativar o registro: ' + FDMCidade.TCidadenome.Value + '?')) then
  begin
    codigo := FDMCidade.TCidadecodigo.Value;

    if (FDMCidade.inativarCidade) then
    begin
      FDMCidade.consultarDados(0);
      FDMCidade.TCidade.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFCidade.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFCidade.DBEstadoDblClick(Sender: TObject);
begin
  try
    Application.CreateForm(TFEstado, FEstado);
    FEstado.consulta := True;
    FEstado.ShowModal;
  finally
    FDMCidade.TCidadecodigoEstado.Value := FDMEstado.TEstadocodigo.Value;
    DBEstadoExit(nil);
    FreeAndNil(FEstado);
  end;
end;

procedure TFCidade.DBEstadoExit(Sender: TObject);
begin
  if (FDMCidade.TCidadecodigoEstado.Value > 0) then
  begin
    FDMEstado.consultarDados(FDMCidade.TCidadecodigoEstado.Value);

    if (FDMEstado.TEstado.RecordCount > 0) then
    begin
      FDMCidade.TCidadenomeEstado.Value := FDMEstado.TEstadonome.Value;
      FDMCidade.TCidadecodigoPais.Value := FDMEstado.TEstadocodigoPais.Value;
      FDMCidade.TCidadenomePais.Value := FDMEstado.TEstadonomePais.Value;
    end
    else
    begin
      DBEstadoDblClick(nil);
    end;
  end
  else
  begin
    DBEstadoDblClick(nil);
  end;
end;

procedure TFCidade.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFCidade.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFCidade.FormShow(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFCidade.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFCidade.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFCidade.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFCidade.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMCidade.TCidadenome.Value = '') then
  begin
    mensagem.Add('O Nome da Cidade deve ser informado!');
  end
  else if (Length(Trim(FDMCidade.TCidadenome.Value)) <= 2) then
  begin
    mensagem.Add('O nome da Cidade deve conter no minimo 3 caracteres validos!');
  end;

  if (Trim(FDMCidade.TCidadecodigoIbge.Value) = '') then
  begin
    mensagem.Add('O codigo do IBGE deve ser informado!');
  end
  else if (Length(Trim(soNumeros(FDMCidade.TCidadecodigoIbge.Value))) <> 7) then
  begin
    mensagem.Add('O codigo do IBGE deve conter 7 caracteres numericos validos!');
  end;

  if not (FDMCidade.TCidadecodigoEstado.Value > 0) then
  begin
    mensagem.Add('O Estado deve ser selecionado!');
  end;
  if (mensagem.Text <> '') then
  begin
    informar(mensagem.Text);
    Result := False;
  end
  else
  begin
    Result := True;
  end;

  FreeAndNil(mensagem);
end;

end.
