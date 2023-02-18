unit TipoDocumento;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows;

type
  TFTipoDocumento = class(TForm)
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
    EMascara: TDBEdit;
    Label3: TLabel;
    ECodigo: TDBEdit;
    EDescricao: TDBEdit;
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
    ELocalizarDescricao: TEdit;
    Label10: TLabel;
    Estado: TLabel;
    DBQtdeCaracteres: TDBEdit;
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
    procedure GDadosDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FTipoDocumento: TFTipoDocumento;

implementation

uses UFuncao, DMTipoDocumento;

{$R *.dfm}

procedure TFTipoDocumento.BAlterarClick(Sender: TObject);
begin
  if not (FDMTipoDocumento.TTipoDocumento.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else
  begin
    UFuncao.desativaBotoes(self);
    FDMTipoDocumento.TTipoDocumento.Edit;
  end;
end;

procedure TFTipoDocumento.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMTipoDocumento.TTipoDocumento.Append;
end;

procedure TFTipoDocumento.BCancelarClick(Sender: TObject);
begin
  PDados.SetFocus;
  FDMTipoDocumento.TTipoDocumento.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFTipoDocumento.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  PDados.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMTipoDocumento.TTipoDocumento.State = dsInsert) then
    begin
      resposta := FDMTipoDocumento.cadastrarTipoDocumento;
    end
    else if (FDMTipoDocumento.TTipoDocumento.State = dsEdit) then
    begin
      resposta := FDMTipoDocumento.alterarTipoDocumento;
    end;

    if (resposta) then
    begin
      FDMTipoDocumento.TTipoDocumento.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFTipoDocumento.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMTipoDocumento.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFTipoDocumento.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFTipoDocumento.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  if not (FDMTipoDocumento.TTipoDocumento.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (UsuarioAdmnistrador) and
          (confirmar('Realmente deseja inativar o registro: ' + FDMTipoDocumento.TTipoDocumentodescricao.Value + '?')) then
  begin
    codigo := FDMTipoDocumento.TTipoDocumentocodigo.Value;

    if (FDMTipoDocumento.inativarTipoDocumento) then
    begin
      FDMTipoDocumento.consultarDados(0);
      FDMTipoDocumento.TTipoDocumento.Locate('codigo', codigo, [loCaseInsensitive]);
    end;
  end
  else if not (UsuarioAdmnistrador) then
  begin
    informar('Usuario sem permissão para excluir informações do banco de dados!');
  end;
end;

procedure TFTipoDocumento.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFTipoDocumento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFTipoDocumento.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFTipoDocumento.FormShow(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFTipoDocumento.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFTipoDocumento.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFTipoDocumento.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

function TFTipoDocumento.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMTipoDocumento.TTipoDocumentodescricao.Value = '') then
  begin
    mensagem.Add('A descrição deve ser informada!');
  end
  else if (Length(Trim(FDMTipoDocumento.TTipoDocumentodescricao.Value)) <= 1) then
  begin
    mensagem.Add('A descrição deve conter no minimo 2 caracteres validos!');
  end
  else if (Length(Trim(FDMTipoDocumento.TTipoDocumentodescricao.Value)) > 10) then
  begin
    mensagem.Add('A descrição deve conter no maximo 10 caracteres validos!');
  end;

  if (Trim(FDMTipoDocumento.TTipoDocumentomascara.Value) = '') then
  begin
    mensagem.Add('A mascara deve ser informada!');
  end
  else if (Length(Trim(FDMTipoDocumento.TTipoDocumentomascara.Value)) <= 2) then
  begin
    mensagem.Add('A mascara deve conter no minimo 3 caracteres numericos validos!');
  end
  else if (Length(Trim(soNumeros(FDMTipoDocumento.TTipoDocumentomascara.Value))) > 30) then
  begin
    mensagem.Add('A mascara deve conter no maximo 30 caracteres numericos validos!');
  end;

  if not (FDMTipoDocumento.TTipoDocumentoqtdeCaracteres.Value > 0) then
  begin
    mensagem.Add('A Quantidade de caracteres deve ser informado!');
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
