unit Pessoa;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows, Vcl.ComCtrls;

type
  TFPessoa = class(TForm)
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
    PFuncao: TPanel;
    Label8: TLabel;
    DBDescricao: TDBEdit;
    DBEdit1: TDBEdit;
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
    procedure DBDescricaoDblClick(Sender: TObject);
    procedure DBDescricaoExit(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
    function confirmarCadastro(confirmar: boolean): Boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FPessoa: TFPessoa;

implementation

uses UFuncao, DMPessoa, OutroDocumento, Endereco, Contato, Funcao, DMFuncao;

{$R *.dfm}

procedure TFPessoa.BAlterarClick(Sender: TObject);
begin
  if not (FDMPessoa.TPessoa.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else
  begin
    UFuncao.desativaBotoes(self);
    FDMPessoa.TPessoa.Edit;

    if (FDMPessoa.tipoCadastro = 'usuario') or
       (FDMPessoa.tipoCadastro = 'funcionario') then
    begin
      PCDados.ActivePage := TBEndereco;
    end
    else
    begin
      PCDados.ActivePage := TBOutrosDocumentos;
    end;
  end;
end;

procedure TFPessoa.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);

  with FDMPessoa do
  begin
    TPessoa.Append;

    if (tipoCadastro = 'usuario') or
       (tipoCadastro = 'funcionario') then
    begin
      PCDados.ActivePage := TBEndereco;

      if (QTipoDocumento.Locate('descricao', 'CPF', [loCaseInsensitive])) then
      begin
        TPessoacodigoTipoDocumento.Value := QTipoDocumentocodigo.Value;
        DBLDocumentoExit(nil);
      end
      else
      begin
        informar('Tipo documento "CPF" não localizado, contate o suporte!');
      end;

      if (tipoCadastro = 'funcionario') then
      begin
        if (FDMFuncao.TFuncao.Locate('descricao', 'NENHUM', [loCaseInsensitive])) then
        begin
          TPessoacodigoFuncao.Value := FDMFuncao.TFuncaocodigo.Value;
          DBDescricaoExit(nil);
        end
        else
        begin
          informar('Função "NENHUM" não localizado, contate o suporte!');
        end;
      end;
    end
    else
    begin
      PCDados.ActivePage := TBOutrosDocumentos;
    end;
  end;
end;

procedure TFPessoa.BCadastrarContatoClick(Sender: TObject);
begin
  if not (FDMPessoa.TPessoacodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFContato, FContato);

    with FDMPessoa do
    begin
      TContato.Append;
      TContatocodigoPessoa.Value := TPessoacodigo.Value;
      TContatodataNascimento.Value := DateToStr(Date);
    end;

    FContato.ShowModal;
  finally
    FreeAndNil(FContato);
  end;
end;

procedure TFPessoa.BCadastrarDocumentoClick(Sender: TObject);
begin
  if not (FDMPessoa.TPessoacodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFOutroDocumento, FOutroDocumento);

    with FDMPessoa do
    begin
      TOutroDocumento.Append;
      TOutroDocumentocodigoPessoa.Value := TPessoacodigo.Value;
      TOutroDocumentodataEmissao.Value := DateToStr(Date);
      TOutroDocumentodataVencimento.Value := DateToStr(Date);
    end;

    FOutroDocumento.ShowModal;
  finally
    FreeAndNil(FOutroDocumento);
  end;
end;

procedure TFPessoa.BCadastrarEnderecoClick(Sender: TObject);
begin
  if not (FDMPessoa.TPessoacodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFEndereco, FEndereco);

    with FDMPessoa do
    begin
      TEndereco.Append;
      TEnderecocodigoPessoa.Value := TPessoacodigo.Value;
    end;

    FEndereco.ShowModal;
  finally
    FreeAndNil(FEndereco);
  end;
end;

procedure TFPessoa.BCancelarClick(Sender: TObject);
begin
  CBInativoContato.Checked := False;
  CBInativoEndereco.Checked := False;
  CBInativoOutroDocumento.Checked := False;

  if (FDMPessoa.TPessoa.State = dsInsert) and
     (FDMPessoa.TPessoacodigo.Value > 0) and
     ((FDMPessoa.TOutroDocumento.RecordCount <= 0) and
      (FDMPessoa.TContato.RecordCount <= 0) and
      (FDMPessoa.TEndereco.RecordCount <= 0)) and
     (FDMPessoa.excluirPessoa = False) then
  begin
    informar('Erro ao cancelar cadastro, contate o suporte!');
  end;

  Painel.SetFocus;
  FDMPessoa.TPessoa.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFPessoa.BConfirmarClick(Sender: TObject);
begin
  confirmarCadastro(True);
end;

procedure TFPessoa.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMPessoa.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFPessoa.BExcluirContatoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMPessoa do
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

procedure TFPessoa.BExcluirEnderecoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMPessoa do
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

procedure TFPessoa.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFPessoa.BInativarClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMPessoa do
  begin
    if not (TPessoa.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (UsuarioAdmnistrador) and
       (confirmar('Realmente deseja inativar o ' + tipoCadastro + ': ' + TPessoanomeFantasia.Value + '?')) then
    begin
      codigo := TPessoacodigo.Value;

      if (inativarPessoa) then
      begin
        consultarDados(0);
        TPessoa.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end
    else if not (UsuarioAdmnistrador) then
    begin
      informar('Usuario sem permissão para excluir informações do banco de dados!');
    end;
  end;
end;

procedure TFPessoa.BRemoverDocumentoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMPessoa do
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

procedure TFPessoa.CBInativoContatoClick(Sender: TObject);
begin
  FDMPessoa.consultarDadosContato(0, False);
end;

procedure TFPessoa.CBInativoEnderecoClick(Sender: TObject);
begin
  FDMPessoa.consultarDadosEndereco(0, False);
end;

procedure TFPessoa.CBInativoOutroDocumentoClick(Sender: TObject);
begin
  FDMPessoa.consultarDadosOutroDocumento(0, False);
end;

procedure TFPessoa.CBMostrarInativoClick(Sender: TObject);
begin
  BConsultarClick(nil);
end;

function TFPessoa.confirmarCadastro(confirmar: boolean): Boolean;
var
  resposta: Boolean;
  mensagem: string;
begin
  Painel.SetFocus;
  resposta := False;

  if (validarCampos) then
  begin
    if (FDMPessoa.TPessoa.State = dsInsert) and
       (FDMPessoa.TPessoacodigo.Value <= 0) then
    begin
      resposta := FDMPessoa.cadastrarPessoa;
    end
    else if (FDMPessoa.TPessoa.State = dsEdit) or
       (FDMPessoa.TPessoacodigo.Value > 0) then
    begin
      resposta := FDMPessoa.alterarPessoa;
    end;

    if (FDMPessoa.tipoCadastro <> 'usuario') and
       (FDMPessoa.tipoCadastro <> 'funcionario') then
    begin
      mensagem := 'Nenhum item (endereço, outro documento ou contato)';
    end
    else
    begin
      mensagem := 'Nenhum endereço';
    end;

    if (FDMPessoa.TPessoa.State = dsInsert) and
       (confirmar) and
       ((FDMPessoa.TOutroDocumento.RecordCount <= 0) and
        (FDMPessoa.TContato.RecordCount <= 0) and
        (FDMPessoa.TEndereco.RecordCount <= 0)) and
       (UFuncao.confirmar(mensagem + ' foi adicionado a esse ' + FDMPessoa.tipoCadastro  +
                          ' realmente deseja continuar?') = False) then
    begin
//   se cair aqui não faz nada
    end
    else if (resposta) and (confirmar) then
    begin
      FDMPessoa.TPessoa.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;

  Result := resposta;
end;

procedure TFPessoa.DBDescricaoDblClick(Sender: TObject);
begin
  try
    Application.CreateForm(TFFuncao, FFuncao);
    FFuncao.consulta := True;
    FFuncao.ShowModal;
  finally
    FDMPessoa.TPessoacodigoFuncao.Value := FDMFuncao.TFuncaocodigo.Value;
    FreeAndNil(FFuncao);
    DBDescricaoExit(nil);
  end;
end;

procedure TFPessoa.DBDescricaoExit(Sender: TObject);
begin
  if (FDMPessoa.TPessoacodigoFuncao.Value > 0) then
  begin
    FDMFuncao.consultarDados(FDMPessoa.TPessoacodigoFuncao.Value);

    if (FDMFuncao.TFuncao.RecordCount > 0) then
    begin
      FDMPessoa.TPessoacodigoFuncao.Value := FDMFuncao.TFuncaocodigo.Value;
      FDMPessoa.TPessoafuncao.Value := FDMFuncao.TFuncaodescricao.Value;
    end
    else
    begin
      DBDescricaoDblClick(nil);
    end;
  end
  else
  begin
    DBDescricaoDblClick(nil);
  end;
end;

procedure TFPessoa.DBDocumentoExit(Sender: TObject);
begin
  with FDMPessoa do
  begin
    if TPessoa.State in[dsInsert, dsEdit] then
    begin
      TPessoadocumento.Value := Trim(soNumeros(TPessoadocumento.Value));
    end;
  end;
end;

procedure TFPessoa.DBLDocumentoExit(Sender: TObject);
begin
  with FDMPessoa do
  begin
    if TPessoa.State in[dsInsert, dsEdit] then
    begin
      TPessoacodigoTipoDocumento.Value := QTipoDocumentocodigo.Value;
      TPessoatipoDocumento.Value := QTipoDocumentodescricao.Value;
      TPessoaqtdeCaracteres.Value := QTipoDocumentoqtdeCaracteres.Value;
      TPessoamascaraCaracteres.Value := QTipoDocumentomascara.Value;
      DBDocumento.SetFocus;
    end;
  end;
end;

procedure TFPessoa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFPessoa.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFPessoa.FormShow(Sender: TObject);
var
  i: Integer;
begin
  PCTela.ActivePage := TBConsulta;

  if (FDMPessoa.tipoCadastro = 'usuario') or
     (FDMPessoa.tipoCadastro = 'funcionario') then
  begin
    PCDados.ActivePage := TBEndereco;

    for i := 0 to GDados.Columns.Count - 1 do
    begin
      if (GDados.Columns.Items[i].FieldName = 'razaoSocial') or
         (GDados.Columns.Items[i].FieldName = 'nomeFantasia') then
      begin
        GDados.Columns.Items[i].Visible := False;
      end
      else if (GDados.Columns.Items[i].FieldName = 'nome') or
              (GDados.Columns.Items[i].FieldName = 'funcao') then
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

  FDMFuncao.consultarDados(0);
  FDMPessoa.consultarTipoDocumento;
  BConsultarClick(nil);
end;

procedure TFPessoa.GContatoDblClick(Sender: TObject);
begin
  if (FDMPessoa.TContato.RecordCount > 0) then
  try
    Application.CreateForm(TFContato, FContato);
    FDMPessoa.TContato.Edit;
    FContato.ShowModal;
  finally
    FreeAndNil(FContato);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
end;

procedure TFPessoa.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFPessoa.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFPessoa.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

procedure TFPessoa.GDocumentoDblClick(Sender: TObject);
begin
  if (FDMPessoa.TOutroDocumento.RecordCount > 0) then
  try
    Application.CreateForm(TFOutroDocumento, FOutroDocumento);
    FDMPessoa.TOutroDocumento.Edit;
    FOutroDocumento.ShowModal;
  finally
    FreeAndNil(FOutroDocumento);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
end;

procedure TFPessoa.GEnderecoDblClick(Sender: TObject);
begin
  if (FDMPessoa.TEndereco.RecordCount > 0) then
  try
    Application.CreateForm(TFEndereco, FEndereco);
    FDMPessoa.TEndereco.Edit;
    FEndereco.ShowModal;
  finally
    FreeAndNil(FEndereco);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
end;

procedure TFPessoa.TBCadastroShow(Sender: TObject);
begin
  with FDMPessoa do
  begin
    if (dadosPessoaConsultados <> TPessoacodigo.Value) then
    begin
      consultarDadosOutroDocumento(0, False);
      consultarDadosEndereco(0, False);
      consultarDadosContato(0, False);
    end;
  end;
end;

function TFPessoa.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if (FDMPessoa.tipoCadastro <> 'usuario') and
     (FDMPessoa.tipoCadastro <> 'funcionario') then
  begin
    if (FDMPessoa.TPessoarazaoSocial.Value = '') then
    begin
      mensagem.Add('A Razão Social deve ser informada!');
    end
    else if (Length(Trim(FDMPessoa.TPessoarazaoSocial.Value)) <= 2) then
    begin
      mensagem.Add('A Razão Social deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(FDMPessoa.TPessoarazaoSocial.Value)) > 150) then
    begin
      mensagem.Add('A Razão Social deve conter no maximo 150 caracteres validos!');
    end;

    if (FDMPessoa.TPessoanomeFantasia.Value = '') then
    begin
      mensagem.Add('O Nome fantasia deve ser informado!');
    end
    else if (Length(Trim(FDMPessoa.TPessoanomeFantasia.Value)) <= 2) then
    begin
      mensagem.Add('O Nome fantasia deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(FDMPessoa.TPessoanomeFantasia.Value)) > 150) then
    begin
      mensagem.Add('O Nome fantasia deve conter no maximo 150 caracteres validos!');
    end;
  end
  else if (FDMPessoa.tipoCadastro = 'usuario') or
          (FDMPessoa.tipoCadastro = 'funcionario') then
  begin
    if (FDMPessoa.TPessoanome.Value = '') then
    begin
      mensagem.Add('O nome deve ser informado!');
    end
    else if (Length(Trim(FDMPessoa.TPessoanome.Value)) <= 2) then
    begin
      mensagem.Add('O nome deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(FDMPessoa.TPessoanome.Value)) > 150) then
    begin
      mensagem.Add('O nome deve conter no maximo 150 caracteres validos!');
    end;

    if (FDMPessoa.tipoCadastro = 'usuario') then
    begin
      if (FDMPessoa.TPessoasenha.Value = '') then
      begin
        mensagem.Add('A senha deve ser informada!');
      end
      else if (Length(Trim(FDMPessoa.TPessoasenha.Value)) <= 2) then
      begin
        mensagem.Add('A senha deve conter no minimo 2 caracteres validos!');
      end
      else if (Length(Trim(FDMPessoa.TPessoasenha.Value)) > 250) then
      begin
        mensagem.Add('A senha deve conter no maximo 250 caracteres validos!');
      end;
    end
    else if (FDMPessoa.tipoCadastro = 'funcionario') then
    begin
      if not (FDMPessoa.TPessoacodigoFuncao.Value > 0) then
      begin
        mensagem.Add('A função deve ser selecionada!');
      end;
    end;
  end;

  if (FDMPessoa.TPessoatipoDocumento.Value = '') then
  begin
    mensagem.Add('O Documento deve ser selecionado!');
  end
  else if (Trim(soNumeros(FDMPessoa.TPessoadocumento.Value)) = '') then
  begin
    mensagem.Add('O Nº do Documento deve ser informado!');
  end
  else if (Length(Trim(soNumeros(FDMPessoa.TPessoadocumento.Value))) <> FDMPessoa.TPessoaqtdeCaracteres.Value) then
  begin
    mensagem.Add('O Nº do Documento deve conter ' + IntToStrSenaoZero(FDMPessoa.TPessoaqtdeCaracteres.Value) +
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
