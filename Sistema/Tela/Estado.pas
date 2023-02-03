unit Estado;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows;

type
  TFEstado = class(TForm)
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
    Label8: TLabel;
    DBPais: TDBEdit;
    DBEdit2: TDBEdit;
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
    procedure DBPaisDblClick(Sender: TObject);
    procedure GDadosDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBPaisExit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FEstado: TFEstado;

implementation

uses UFuncao, DMEstado, DMPais, Pais;

{$R *.dfm}

procedure TFEstado.BAlterarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMEstado.TEstado.Edit;
end;

procedure TFEstado.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMEstado.TEstado.Append;
end;

procedure TFEstado.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMEstado.TEstado.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFEstado.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;

  if (validarCampos) then
  begin
    if (FDMEstado.TEstado.State = dsInsert) then
    begin
      resposta := FDMEstado.cadastrarEstado;
    end
    else if (FDMEstado.TEstado.State = dsEdit) then
    begin
      resposta := FDMEstado.alterarEstado;
    end;

    if (resposta) then
    begin
      FDMEstado.TEstado.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFEstado.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMEstado.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFEstado.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFEstado.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if (UsuarioAdmnistrador) and
     (confirmar('Realmente deseja inativar o registro: ' + FDMEstado.TEstadonome.Value + '?')) then
  begin
    codigo := FDMEstado.TEstadocodigo.Value;

    if (FDMEstado.inativarEstado) then
    begin
      FDMEstado.consultarDados(0);
      FDMEstado.TEstado.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFEstado.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFEstado.DBPaisDblClick(Sender: TObject);
begin
  try
    Application.CreateForm(TFPais, FPais);
    FPais.consulta := True;
    FPais.ShowModal;
  finally
    FDMEstado.TEstadocodigoPais.Value := FDMPais.TPaiscodigo.Value;
    DBPaisExit(nil);
    FreeAndNil(FPais);
  end;
end;

procedure TFEstado.DBPaisExit(Sender: TObject);
begin
  if (FDMEstado.TEstadocodigoPais.Value > 0) then
  begin
    FDMPais.consultarDados(FDMEstado.TEstadocodigoPais.Value);

    if (FDMPais.TPais.RecordCount > 0) then
    begin
      FDMEstado.TEstadonomePais.Value := FDMPais.TPaisnome.Value;
    end
    else
    begin
      DBPaisDblClick(nil);
    end;
  end
  else
  begin
    DBPaisDblClick(nil);
  end;
end;

procedure TFEstado.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFEstado.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFEstado.FormShow(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFEstado.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFEstado.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFEstado.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFEstado.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMEstado.TEstadonome.Value = '') then
  begin
    mensagem.Add('O Nome do Estado deve ser informado!');
  end
  else if (Length(Trim(FDMEstado.TEstadonome.Value)) <= 2) then
  begin
    mensagem.Add('O nome do Estado deve conter no minimo 3 caracteres validos!');
  end;

  if (Trim(FDMEstado.TEstadocodigoIbge.Value) = '') then
  begin
    mensagem.Add('O codigo do IBGE deve ser informado!');
  end
  else if (Length(Trim(soNumeros(FDMEstado.TEstadocodigoIbge.Value))) <> 2) then
  begin
    mensagem.Add('O codigo do IBGE deve conter 2 caracteres numericos validos!');
  end;

  if not (FDMEstado.TEstadocodigoPais.Value > 0) then
  begin
    mensagem.Add('O País deve ser selecionado!');
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
