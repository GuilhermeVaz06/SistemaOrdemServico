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
    LConsultaRazaoSocial: TLabel;
    ERazaoSocial: TEdit;
    GDados: TDBGrid;
    CBMostrarInativo: TCheckBox;
    LConsultaNomeFantasia: TLabel;
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
    LRazaoSocial: TLabel;
    LNomeFantasia: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ECodigo: TDBEdit;
    DBDocumento: TDBEdit;
    DBLDocumento: TDBLookupComboBox;
    DBRazaoSocial: TDBEdit;
    DBNomeFantasia: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBMemo1: TDBMemo;
    SpeedButton1: TSpeedButton;
    CBInativoOutroDocumento: TCheckBox;
    Panel1: TPanel;
    BCadastrarEndereco: TSpeedButton;
    BExcluirEndereco: TSpeedButton;
    GEndereco: TDBGrid;
    CBInativoEndereco: TCheckBox;
    Panel4: TPanel;
    BCadastrarContato: TSpeedButton;
    BExcluirContato: TSpeedButton;
    GContato: TDBGrid;
    CBInativoContato: TCheckBox;
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
    procedure DBLDocumentoExit(Sender: TObject);
    procedure DBDocumentoExit(Sender: TObject);
    procedure BCadastrarDocumentoClick(Sender: TObject);
    procedure BRemoverDocumentoClick(Sender: TObject);
    procedure TBCadastroShow(Sender: TObject);
    procedure CBInativoOutroDocumentoClick(Sender: TObject);
    procedure GDocumentoDblClick(Sender: TObject);
    procedure GEnderecoDblClick(Sender: TObject);
    procedure BCadastrarEnderecoClick(Sender: TObject);
    procedure BExcluirEnderecoClick(Sender: TObject);
    procedure CBInativoEnderecoClick(Sender: TObject);
    procedure GContatoDblClick(Sender: TObject);
    procedure BExcluirContatoClick(Sender: TObject);
    procedure BCadastrarContatoClick(Sender: TObject);
    procedure CBInativoContatoClick(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
    function confirmarCadastro(confirmar: boolean): Boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FClienteFornecedor: TFClienteFornecedor;

implementation

uses UFuncao, DMClienteFornecedor, OutroDocumento, Endereco, Contato;

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

    if (FDMClienteFornecedor.tipoCadastro = 'usuario') then
    begin
      PCDados.ActivePage := TBEndereco;
    end
    else
    begin
      PCDados.ActivePage := TBOutrosDocumentos;
    end;
  end;
end;

procedure TFClienteFornecedor.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);

  with FDMClienteFornecedor do
  begin
    TClienteFornecedor.Append;

    if (tipoCadastro = 'usuario') then
    begin
      PCDados.ActivePage := TBEndereco;

      if (QTipoDocumento.Locate('descricao', 'CPF', [loCaseInsensitive])) then
      begin
        TClienteFornecedorcodigoTipoDocumento.Value := QTipoDocumentocodigo.Value;
        DBLDocumentoExit(nil);
      end
      else
      begin
        informar('Tipo documento "CPF" não localizado, contate o suporte!');
      end;
    end
    else
    begin
      PCDados.ActivePage := TBOutrosDocumentos;
    end;
  end;
end;

procedure TFClienteFornecedor.BCadastrarContatoClick(Sender: TObject);
begin
  if not (FDMClienteFornecedor.TClienteFornecedorcodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFContato, FContato);

    with FDMClienteFornecedor do
    begin
      TContato.Append;
      TContatocodigoPessoa.Value := TClienteFornecedorcodigo.Value;
      TContatodataNascimento.Value := DateToStr(Date);
    end;

    FContato.ShowModal;
  finally
    FreeAndNil(FContato);
  end;
end;

procedure TFClienteFornecedor.BCadastrarDocumentoClick(Sender: TObject);
begin
  if not (FDMClienteFornecedor.TClienteFornecedorcodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFOutroDocumento, FOutroDocumento);

    with FDMClienteFornecedor do
    begin
      TOutroDocumento.Append;
      TOutroDocumentocodigoPessoa.Value := TClienteFornecedorcodigo.Value;
      TOutroDocumentodataEmissao.Value := DateToStr(Date);
      TOutroDocumentodataVencimento.Value := DateToStr(Date);
    end;

    FOutroDocumento.ShowModal;
  finally
    FreeAndNil(FOutroDocumento);
  end;
end;

procedure TFClienteFornecedor.BCadastrarEnderecoClick(Sender: TObject);
begin
  if not (FDMClienteFornecedor.TClienteFornecedorcodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFEndereco, FEndereco);

    with FDMClienteFornecedor do
    begin
      TEndereco.Append;
      TEnderecocodigoPessoa.Value := TClienteFornecedorcodigo.Value;
    end;

    FEndereco.ShowModal;
  finally
    FreeAndNil(FEndereco);
  end;
end;

procedure TFClienteFornecedor.BCancelarClick(Sender: TObject);
begin
  CBInativoContato.Checked := False;
  CBInativoEndereco.Checked := False;
  CBInativoOutroDocumento.Checked := False;

  if (FDMClienteFornecedor.TClienteFornecedor.State = dsInsert) and
     (FDMClienteFornecedor.TClienteFornecedorcodigo.Value > 0) and
     ((FDMClienteFornecedor.TOutroDocumento.RecordCount <= 0) and
      (FDMClienteFornecedor.TContato.RecordCount <= 0) and
      (FDMClienteFornecedor.TEndereco.RecordCount <= 0)) and
     (FDMClienteFornecedor.excluirPessoa = False) then
  begin
    informar('Erro ao cancelar cadastro, contate o suporte!');
  end;

  Painel.SetFocus;
  FDMClienteFornecedor.TClienteFornecedor.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFClienteFornecedor.BConfirmarClick(Sender: TObject);
begin
  confirmarCadastro(True);
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

procedure TFClienteFornecedor.BExcluirContatoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMClienteFornecedor do
  begin
    if not (TContato.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (confirmar('Realmente deseja inativar o contato: ' + TContatonome.Value + '?')) then
    begin
      codigo := TContatocodigo.Value;

      if (inativarContato) then
      begin
        consultarDadosContato(0, True);
        TContato.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end;
  end;
end;

procedure TFClienteFornecedor.BExcluirEnderecoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMClienteFornecedor do
  begin
    if not (TEndereco.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (confirmar('Realmente deseja inativar o endereço: ' + TEnderecolongradouro.Value + ' - ' + TEndereconumero.Value + '?')) then
    begin
      codigo := TEnderecocodigo.Value;

      if (inativarEndereco) then
      begin
        consultarDadosEndereco(0, True);
        TEndereco.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end;
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

procedure TFClienteFornecedor.CBInativoContatoClick(Sender: TObject);
begin
  FDMClienteFornecedor.consultarDadosContato(0, False);
end;

procedure TFClienteFornecedor.CBInativoEnderecoClick(Sender: TObject);
begin
  FDMClienteFornecedor.consultarDadosEndereco(0, False);
end;

procedure TFClienteFornecedor.CBInativoOutroDocumentoClick(Sender: TObject);
begin
  FDMClienteFornecedor.consultarDadosOutroDocumento(0, False);
end;

procedure TFClienteFornecedor.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

function TFClienteFornecedor.confirmarCadastro(confirmar: boolean): Boolean;
var
  resposta: Boolean;
  mensagem: string;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMClienteFornecedor.TClienteFornecedor.State = dsInsert) and
       (FDMClienteFornecedor.TClienteFornecedorcodigo.Value <= 0) then
    begin
      resposta := FDMClienteFornecedor.cadastrarClienteFornecedor;
    end
    else if (FDMClienteFornecedor.TClienteFornecedor.State = dsEdit) or
       (FDMClienteFornecedor.TClienteFornecedorcodigo.Value > 0) then
    begin
      resposta := FDMClienteFornecedor.alterarClienteFornecedor;
    end;

    if (FDMClienteFornecedor.tipoCadastro <> 'usuario') then
    begin
      mensagem := 'Nenhum item (endereço, outro documento ou contato)';
    end
    else
    begin
      mensagem := 'Nenhum endereço';
    end;

    if (FDMClienteFornecedor.TClienteFornecedor.State = dsInsert) and
       (confirmar) and
       ((FDMClienteFornecedor.TOutroDocumento.RecordCount <= 0) and
        (FDMClienteFornecedor.TContato.RecordCount <= 0) and
        (FDMClienteFornecedor.TEndereco.RecordCount <= 0)) and
       (UFuncao.confirmar(mensagem + ' foi adicionado a esse ' + FDMClienteFornecedor.tipoCadastro  +
                          ' realmente deseja continuar?') = False) then
    begin
//   se cair aqui não faz nada
    end
    else if (resposta) and (confirmar) then
    begin
      FDMClienteFornecedor.TClienteFornecedor.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;

  Result := resposta;
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

procedure TFClienteFornecedor.DBLDocumentoExit(Sender: TObject);
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
var
  i: Integer;
begin
  PCTela.ActivePage := TBConsulta;

  if (FDMClienteFornecedor.tipoCadastro = 'usuario') then
  begin
    PCDados.ActivePage := TBEndereco;

    for i := 0 to GDados.Columns.Count - 1 do
    begin
      if (GDados.Columns.Items[i].FieldName = 'razaoSocial') or
         (GDados.Columns.Items[i].FieldName = 'nomeFantasia') then
      begin
        GDados.Columns.Items[i].Visible := False;
      end
      else if (GDados.Columns.Items[i].FieldName = 'nome') then
      begin
        GDados.Columns.Items[i].Visible := True;
        GDados.Columns.Items[i].Width := 117;
      end;
    end;
  end
  else
  begin
    PCDados.ActivePage := TBOutrosDocumentos;
  end;


  FDMClienteFornecedor.consultarTipoDocumento;
  BConsultarClick(nil);
end;

procedure TFClienteFornecedor.GContatoDblClick(Sender: TObject);
begin
  if (FDMClienteFornecedor.TContato.RecordCount > 0) then
  try
    Application.CreateForm(TFContato, FContato);
    FDMClienteFornecedor.TContato.Edit;
    FContato.ShowModal;
  finally
    FreeAndNil(FContato);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
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

procedure TFClienteFornecedor.GEnderecoDblClick(Sender: TObject);
begin
  if (FDMClienteFornecedor.TEndereco.RecordCount > 0) then
  try
    Application.CreateForm(TFEndereco, FEndereco);
    FDMClienteFornecedor.TEndereco.Edit;
    FEndereco.ShowModal;
  finally
    FreeAndNil(FEndereco);
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
      consultarDadosEndereco(0, False);
      consultarDadosContato(0, False);
    end;
  end;
end;

function TFClienteFornecedor.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMClienteFornecedor.tipoCadastro <> 'usuario') then
  begin
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
  end
  else
  begin
    if (FDMClienteFornecedor.TClienteFornecedornome.Value = '') then
    begin
      mensagem.Add('O nome deve ser informado!');
    end
    else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedornome.Value)) <= 2) then
    begin
      mensagem.Add('O nome deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedornome.Value)) > 150) then
    begin
      mensagem.Add('O nome deve conter no maximo 150 caracteres validos!');
    end;

    if (FDMClienteFornecedor.TClienteFornecedorsenha.Value = '') then
    begin
      mensagem.Add('A senha deve ser informada!');
    end
    else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedorsenha.Value)) <= 2) then
    begin
      mensagem.Add('A senha deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(FDMClienteFornecedor.TClienteFornecedorsenha.Value)) > 250) then
    begin
      mensagem.Add('A senha deve conter no maximo 250 caracteres validos!');
    end;
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
