unit ClienteFornecedor;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows, Vcl.ComCtrls;

type
  TFClienteFornecedor = class(TForm)
    PCTela: TPageControl;
    TBCadastro: TTabSheet;
    TBConsulta: TTabSheet;
    Panel3: TPanel;
    BConsultar: TSpeedButton;
    Label10: TLabel;
    ERazaoSocial: TEdit;
    GDados: TDBGrid;
    CBMostrarInativo: TCheckBox;
    Label14: TLabel;
    ENomeFantasia: TEdit;
    Painel: TPanel;
    BFechar: TSpeedButton;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
    BInativar: TSpeedButton;
    BAlterar: TSpeedButton;
    BCadastrar: TSpeedButton;
    DBNavigator1: TDBNavigator;
    PInfo: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ECadastradoPor: TDBEdit;
    EAlteradoPor: TDBEdit;
    EDataCadastro: TDBEdit;
    EDataAlteracao: TDBEdit;
    CBAtivo: TDBCheckBox;
    PCDados: TPageControl;
    TBOutrosDocumentos: TTabSheet;
    Panel2: TPanel;
    BCadastrarDocumento: TSpeedButton;
    BRemoverDocumento: TSpeedButton;
    GDocumento: TDBGrid;
    TBEndereco: TTabSheet;
    TBContato: TTabSheet;
    PDados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ECodigo: TDBEdit;
    DBDocumento: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBMemo1: TDBMemo;
    SpeedButton1: TSpeedButton;
    CBInativoOutroDocumento: TCheckBox;
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
    procedure DBLookupComboBox1Exit(Sender: TObject);
    procedure DBDocumentoExit(Sender: TObject);
    procedure BCadastrarDocumentoClick(Sender: TObject);
    procedure BRemoverDocumentoClick(Sender: TObject);
    procedure TBCadastroShow(Sender: TObject);
    procedure CBInativoOutroDocumentoClick(Sender: TObject);
    procedure GDocumentoDblClick(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FClienteFornecedor: TFClienteFornecedor;

implementation

uses UFuncao, DMClienteFornecedor, OutroDocumento;

{$R *.dfm}

procedure TFClienteFornecedor.BAlterarClick(Sender: TObject);
begin
  if not (FDMClienteFornecedor.TClienteFornecedor.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else
  begin
    UFuncao.desativaBotoes(self);
    FDMClienteFornecedor.TClienteFornecedor.Edit;
    PCDados.ActivePage := TBOutrosDocumentos;
  end;
end;

procedure TFClienteFornecedor.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMClienteFornecedor.TClienteFornecedor.Append;
  PCDados.ActivePage := TBOutrosDocumentos;
end;

procedure TFClienteFornecedor.BCadastrarDocumentoClick(Sender: TObject);
begin
  if (FDMClienteFornecedor.TClienteFornecedorcodigo.Value > 0) then
  try
    Application.CreateForm(TFOutroDocumento, FOutroDocumento);

    with FDMClienteFornecedor do
    begin
      TOutroDocumento.Append;
      TOutroDocumentocodigoPessoa.Value := TClienteFornecedorcodigo.Value;
      TOutroDocumentodataEmissao.Value := Date;
      TOutroDocumentodataVencimento.Value := Date;
    end;

    FOutroDocumento.ShowModal;
  finally
    FreeAndNil(FOutroDocumento);
  end
  else
  begin
    informar('Antes de inserir um outro documento confirme o cadastro do ' + FDMClienteFornecedor.tipoCadastro);
  end;
end;

procedure TFClienteFornecedor.BCancelarClick(Sender: TObject);
begin
  Painel.SetFocus;
  FDMClienteFornecedor.TClienteFornecedor.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFClienteFornecedor.BConfirmarClick(Sender: TObject);
var
  resposta: Boolean;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMClienteFornecedor.TClienteFornecedor.State = dsInsert) then
    begin
      resposta := FDMClienteFornecedor.cadastrarClienteFornecedor;
    end
    else if (FDMClienteFornecedor.TClienteFornecedor.State = dsEdit) then
    begin
      resposta := FDMClienteFornecedor.alterarClienteFornecedor;
    end;

    if (resposta) then
    begin
      FDMClienteFornecedor.TClienteFornecedor.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;
end;

procedure TFClienteFornecedor.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMClienteFornecedor.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFClienteFornecedor.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFClienteFornecedor.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMClienteFornecedor do
  begin
    if not (TClienteFornecedor.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (UsuarioAdmnistrador) and
       (confirmar('Realmente deseja inativar o ' + tipoCadastro + ': ' + TClienteFornecedornomeFantasia.Value + '?')) then
    begin
      codigo := TClienteFornecedorcodigo.Value;

      if (inativarClienteFornecedor) then
      begin
        consultarDados(0);
        TClienteFornecedor.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end
    else if not (UsuarioAdmnistrador) then
    begin
      informar('Usuario sem permissão para excluir informações do banco de dados!');
    end;
  end;
end;

procedure TFClienteFornecedor.BRemoverDocumentoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMClienteFornecedor do
  begin
    if not (TOutroDocumento.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (confirmar('Realmente deseja inativar o Outro Documento: ' + TOutroDocumentodocumento.Value + '?')) then
    begin
      codigo := TOutroDocumentocodigo.Value;

      if (inativarOutroDocumento) then
      begin
        consultarDadosOutroDocumento(0, True);
        TOutroDocumento.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end;
  end;
end;

procedure TFClienteFornecedor.CBInativoOutroDocumentoClick(Sender: TObject);
begin
  FDMClienteFornecedor.consultarDadosOutroDocumento(0, False);
end;

procedure TFClienteFornecedor.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

procedure TFClienteFornecedor.DBDocumentoExit(Sender: TObject);
begin
  with FDMClienteFornecedor do
  begin
    if TClienteFornecedor.State in[dsInsert, dsEdit] then
    begin
      TClienteFornecedordocumento.Value := Trim(soNumeros(TClienteFornecedordocumento.Value));
    end;
  end;
end;

procedure TFClienteFornecedor.DBLookupComboBox1Exit(Sender: TObject);
begin
  with FDMClienteFornecedor do
  begin
    if TClienteFornecedor.State in[dsInsert, dsEdit] then
    begin
      TClienteFornecedorcodigoTipoDocumento.Value := QTipoDocumentocodigo.Value;
      TClienteFornecedortipoDocumento.Value := QTipoDocumentodescricao.Value;
      TClienteFornecedorqtdeCaracteres.Value := QTipoDocumentoqtdeCaracteres.Value;
      TClienteFornecedormascaraCaracteres.Value := QTipoDocumentomascara.Value;
      DBDocumento.SetFocus;
    end;
  end;
end;

procedure TFClienteFornecedor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFClienteFornecedor.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFClienteFornecedor.FormShow(Sender: TObject);
begin
  PCTela.ActivePage := TBConsulta;
  FDMClienteFornecedor.consultarTipoDocumento;
  BConsultarClick(nil);
end;

procedure TFClienteFornecedor.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFClienteFornecedor.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFClienteFornecedor.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

procedure TFClienteFornecedor.GDocumentoDblClick(Sender: TObject);
begin
  if (FDMClienteFornecedor.TOutroDocumento.RecordCount > 0) then
  try
    Application.CreateForm(TFOutroDocumento, FOutroDocumento);
    FDMClienteFornecedor.TOutroDocumento.Edit;
    FOutroDocumento.ShowModal;
  finally
    FreeAndNil(FOutroDocumento);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
end;

procedure TFClienteFornecedor.TBCadastroShow(Sender: TObject);
begin
  with FDMClienteFornecedor do
  begin
    if (dadosPessoaConsultados <> TClienteFornecedorcodigo.Value) then
    begin
      consultarDadosOutroDocumento(0, False);
    end;
  end;
end;

function TFClienteFornecedor.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMClienteFornecedor.TClienteFornecedorrazaoSocial.Value = '') then
  begin
    mensagem.Add('A Razão Social deve ser informada!');
  end
  else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedorrazaoSocial.Value)) <= 2) then
  begin
    mensagem.Add('A Razão Social deve conter no minimo 2 caracteres validos!');
  end
  else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedorrazaoSocial.Value)) > 150) then
  begin
    mensagem.Add('A Razão Social deve conter no maximo 150 caracteres validos!');
  end;

  if (FDMClienteFornecedor.TClienteFornecedornomeFantasia.Value = '') then
  begin
    mensagem.Add('O Nome fantasia deve ser informado!');
  end
  else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedornomeFantasia.Value)) <= 2) then
  begin
    mensagem.Add('O Nome fantasia deve conter no minimo 2 caracteres validos!');
  end
  else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedornomeFantasia.Value)) > 150) then
  begin
    mensagem.Add('O Nome fantasia deve conter no maximo 150 caracteres validos!');
  end;

  if (FDMClienteFornecedor.TClienteFornecedortipoDocumento.Value = '') then
  begin
    mensagem.Add('O Documento deve ser selecionado!');
  end
  else if (Trim(soNumeros(FDMClienteFornecedor.TClienteFornecedordocumento.Value)) = '') then
  begin
    mensagem.Add('O Nº do Documento deve ser informado!');
  end
  else if (Length(Trim(soNumeros(FDMClienteFornecedor.TClienteFornecedordocumento.Value))) <> FDMClienteFornecedor.TClienteFornecedorqtdeCaracteres.Value) then
  begin
    mensagem.Add('O Nº do Documento deve conter ' + IntToStrSenaoZero(FDMClienteFornecedor.TClienteFornecedorqtdeCaracteres.Value) +
                 ' caracteres validos!');
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
