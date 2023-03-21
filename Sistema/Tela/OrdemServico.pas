unit OrdemServico;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows, Vcl.ComCtrls;

type
  TFOrdemServico = class(TForm)
    PCTela: TPageControl;
    TBCadastro: TTabSheet;
    TBConsulta: TTabSheet;
    Panel3: TPanel;
    BConsultar: TSpeedButton;
    LConsultaRazaoSocial: TLabel;
    ERazaoSocial: TEdit;
    GDados: TDBGrid;
    CBMostrarInativo: TCheckBox;
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
    PCDados: TPageControl;
    TBOutrosDocumentos: TTabSheet;
    Panel2: TPanel;
    BCadastrarDocumento: TSpeedButton;
    BRemoverDocumento: TSpeedButton;
    TBEndereco: TTabSheet;
    TBContato: TTabSheet;
    PDados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ECodigo: TDBEdit;
    DBLDocumento: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    BCadastrarEndereco: TSpeedButton;
    BExcluirEndereco: TSpeedButton;
    CBInativoEndereco: TCheckBox;
    Panel4: TPanel;
    BCadastrarContato: TSpeedButton;
    BExcluirContato: TSpeedButton;
    CBInativoContato: TCheckBox;
    GEndereco: TDBGrid;
    GDocumento: TDBGrid;
    GContato: TDBGrid;
    Label13: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBDescricao: TDBEdit;
    Label8: TLabel;
    DBMemo2: TDBMemo;
    Label9: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Label10: TLabel;
    DBEdit4: TDBEdit;
    Label11: TLabel;
    DBEdit5: TDBEdit;
    Label12: TLabel;
    DBEdit6: TDBEdit;
    Label14: TLabel;
    DBEdit7: TDBEdit;
    Label15: TLabel;
    DBEdit8: TDBEdit;
    Label16: TLabel;
    DBEdit9: TDBEdit;
    Label18: TLabel;
    DBEdit10: TDBEdit;
    Label19: TLabel;
    DBEdit11: TDBEdit;
    Label20: TLabel;
    Label21: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    Label22: TLabel;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    Label23: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    DBEdit14: TDBEdit;
    Label24: TLabel;
    Label25: TLabel;
    EDTEmissao: TDateTimePicker;
    Label26: TLabel;
    EDTVencimento: TDateTimePicker;
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
    procedure GDadosTitleClick(Column: TColumn);
    procedure GDadosDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TBCadastroShow(Sender: TObject);
  private
    { Private declarations }
    function validarCampos: boolean;
    function confirmarCadastro(confirmar: boolean): Boolean;
  public
    { Public declarations }
    consulta: Boolean;
  end;

var
  FOrdemServico: TFOrdemServico;

implementation

uses UFuncao, DMPessoa, OutroDocumento, Endereco, Contato, Funcao, DMFuncao;

{$R *.dfm}

procedure TFOrdemServico.BAlterarClick(Sender: TObject);
begin
//  if not (FDMPessoa.TPessoa.RecordCount > 0) then
//  begin
//    informar('Nenhum registro selecionado!');
//  end
//  else
//  begin
//    UFuncao.desativaBotoes(self);
//    FDMPessoa.TPessoa.Edit;
//
//    if (FDMPessoa.tipoCadastro = 'usuario') or
//       (FDMPessoa.tipoCadastro = 'funcionario') then
//    begin
//      PCDados.ActivePage := TBEndereco;
//    end
//    else
//    begin
//      PCDados.ActivePage := TBOutrosDocumentos;
//    end;
//  end;
end;

procedure TFOrdemServico.BCadastrarClick(Sender: TObject);
begin
//  UFuncao.desativaBotoes(self);
//
//  with FDMPessoa do
//  begin
//    TPessoa.Append;
//
//    if (tipoCadastro = 'usuario') or
//       (tipoCadastro = 'funcionario') then
//    begin
//      PCDados.ActivePage := TBEndereco;
//
//      if (QTipoDocumento.Locate('descricao', 'CPF', [loCaseInsensitive])) then
//      begin
//        TPessoacodigoTipoDocumento.Value := QTipoDocumentocodigo.Value;
//        DBLDocumentoExit(nil);
//      end
//      else
//      begin
//        informar('Tipo documento "CPF" não localizado, contate o suporte!');
//      end;
//
//      if (tipoCadastro = 'funcionario') then
//      begin
//        if (FDMFuncao.TFuncao.Locate('descricao', 'NENHUM', [loCaseInsensitive])) then
//        begin
//          TPessoacodigoFuncao.Value := FDMFuncao.TFuncaocodigo.Value;
//          DBDescricaoExit(nil);
//        end
//        else
//        begin
//          informar('Função "NENHUM" não localizado, contate o suporte!');
//        end;
//      end;
//    end
//    else
//    begin
//      PCDados.ActivePage := TBOutrosDocumentos;
//    end;
//  end;
end;

procedure TFOrdemServico.BCancelarClick(Sender: TObject);
begin
//  CBInativoContato.Checked := False;
//  CBInativoEndereco.Checked := False;
//  CBInativoOutroDocumento.Checked := False;
//
//  if (FDMPessoa.TPessoa.State = dsInsert) and
//     (FDMPessoa.TPessoacodigo.Value > 0) and
//     ((FDMPessoa.TOutroDocumento.RecordCount <= 0) and
//      (FDMPessoa.TContato.RecordCount <= 0) and
//      (FDMPessoa.TEndereco.RecordCount <= 0)) and
//     (FDMPessoa.excluirPessoa = False) then
//  begin
//    informar('Erro ao cancelar cadastro, contate o suporte!');
//  end;
//
//  Painel.SetFocus;
//  FDMPessoa.TPessoa.Cancel;
//  UFuncao.desativaBotoes(self);
end;

procedure TFOrdemServico.BConfirmarClick(Sender: TObject);
begin
//  confirmarCadastro(True);
end;

procedure TFOrdemServico.BConsultarClick(Sender: TObject);
begin
//  BConsultar.Enabled := False;
//
//  try
//    FDMPessoa.consultarDados(0);
//  finally
//    BConsultar.Enabled := True;
//  end;
end;

procedure TFOrdemServico.BFecharClick(Sender: TObject);
begin
  close;
end;

function TFOrdemServico.confirmarCadastro(confirmar: boolean): Boolean;
var
  resposta: Boolean;
  mensagem: string;
begin
//  Painel.SetFocus;
//  resposta := False;
//
//  if (validarCampos) then
//  begin
//    if (FDMPessoa.TPessoa.State = dsInsert) and
//       (FDMPessoa.TPessoacodigo.Value <= 0) then
//    begin
//      resposta := FDMPessoa.cadastrarPessoa;
//    end
//    else if (FDMPessoa.TPessoa.State = dsEdit) or
//       (FDMPessoa.TPessoacodigo.Value > 0) then
//    begin
//      resposta := FDMPessoa.alterarPessoa;
//    end;
//
//    if (FDMPessoa.tipoCadastro <> 'usuario') and
//       (FDMPessoa.tipoCadastro <> 'funcionario') then
//    begin
//      mensagem := 'Nenhum item (endereço, outro documento ou contato)';
//    end
//    else
//    begin
//      mensagem := 'Nenhum endereço';
//    end;
//
//    if (FDMPessoa.TPessoa.State = dsInsert) and
//       (confirmar) and
//       ((FDMPessoa.TOutroDocumento.RecordCount <= 0) and
//        (FDMPessoa.TContato.RecordCount <= 0) and
//        (FDMPessoa.TEndereco.RecordCount <= 0)) and
//       (UFuncao.confirmar(mensagem + ' foi adicionado a esse ' + FDMPessoa.tipoCadastro  +
//                          ' realmente deseja continuar?') = False) then
//    begin
////   se cair aqui não faz nada
//    end
//    else if (resposta) and (confirmar) then
//    begin
//      FDMPessoa.TPessoa.Post;
//      UFuncao.desativaBotoes(self);
//    end;
//  end;
//
//  Result := resposta;
end;

procedure TFOrdemServico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BConfirmar.Enabled then
  begin
    Abort;
  end;
end;

procedure TFOrdemServico.FormCreate(Sender: TObject);
begin
  consulta := False;
end;

procedure TFOrdemServico.FormShow(Sender: TObject);
var
  i: Integer;
begin
//  PCTela.ActivePage := TBConsulta;
//
//  if (FDMPessoa.tipoCadastro = 'usuario') or
//     (FDMPessoa.tipoCadastro = 'funcionario') then
//  begin
//    PCDados.ActivePage := TBEndereco;
//
//    for i := 0 to GDados.Columns.Count - 1 do
//    begin
//      if (GDados.Columns.Items[i].FieldName = 'razaoSocial') or
//         (GDados.Columns.Items[i].FieldName = 'nomeFantasia') then
//      begin
//        GDados.Columns.Items[i].Visible := False;
//      end
//      else if (GDados.Columns.Items[i].FieldName = 'nome') or
//              (GDados.Columns.Items[i].FieldName = 'funcao') then
//      begin
//        GDados.Columns.Items[i].Visible := True;
//        GDados.Columns.Items[i].Width := 117;
//      end;
//    end;
//  end
//  else
//  begin
//    PCDados.ActivePage := TBOutrosDocumentos;
//  end;
//
//  FDMFuncao.consultarDados(0);
//  FDMPessoa.consultarTipoDocumento;
//  BConsultarClick(nil);
end;

procedure TFOrdemServico.GDadosDblClick(Sender: TObject);
begin
  if (consulta) then
  begin
    BFecharClick(nil);
  end;
end;

procedure TFOrdemServico.GDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  colorirGrid(Sender, Rect, DataCol, Column, State);
end;

procedure TFOrdemServico.GDadosTitleClick(Column: TColumn);
begin
  OrdenarGrid(Column);
end;

procedure TFOrdemServico.TBCadastroShow(Sender: TObject);
begin
//  with FDMPessoa do
//  begin
//    if (dadosPessoaConsultados <> TPessoacodigo.Value) then
//    begin
//      consultarDadosOutroDocumento(0, False);
//      consultarDadosEndereco(0, False);
//      consultarDadosContato(0, False);
//    end;
//  end;
end;

function TFOrdemServico.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

//  if (FDMPessoa.tipoCadastro <> 'usuario') and
//     (FDMPessoa.tipoCadastro <> 'funcionario') then
//  begin
//    if (FDMPessoa.TPessoarazaoSocial.Value = '') then
//    begin
//      mensagem.Add('A Razão Social deve ser informada!');
//    end
//    else if (Length(Trim(FDMPessoa.TPessoarazaoSocial.Value)) <= 2) then
//    begin
//      mensagem.Add('A Razão Social deve conter no minimo 2 caracteres validos!');
//    end
//    else if (Length(Trim(FDMPessoa.TPessoarazaoSocial.Value)) > 150) then
//    begin
//      mensagem.Add('A Razão Social deve conter no maximo 150 caracteres validos!');
//    end;
//
//    if (FDMPessoa.TPessoanomeFantasia.Value = '') then
//    begin
//      mensagem.Add('O Nome fantasia deve ser informado!');
//    end
//    else if (Length(Trim(FDMPessoa.TPessoanomeFantasia.Value)) <= 2) then
//    begin
//      mensagem.Add('O Nome fantasia deve conter no minimo 2 caracteres validos!');
//    end
//    else if (Length(Trim(FDMPessoa.TPessoanomeFantasia.Value)) > 150) then
//    begin
//      mensagem.Add('O Nome fantasia deve conter no maximo 150 caracteres validos!');
//    end;
//  end
//  else if (FDMPessoa.tipoCadastro = 'usuario') or
//          (FDMPessoa.tipoCadastro = 'funcionario') then
//  begin
//    if (FDMPessoa.TPessoanome.Value = '') then
//    begin
//      mensagem.Add('O nome deve ser informado!');
//    end
//    else if (Length(Trim(FDMPessoa.TPessoanome.Value)) <= 2) then
//    begin
//      mensagem.Add('O nome deve conter no minimo 2 caracteres validos!');
//    end
//    else if (Length(Trim(FDMPessoa.TPessoanome.Value)) > 150) then
//    begin
//      mensagem.Add('O nome deve conter no maximo 150 caracteres validos!');
//    end;
//
//    if (FDMPessoa.tipoCadastro = 'usuario') then
//    begin
//      if (FDMPessoa.TPessoasenha.Value = '') then
//      begin
//        mensagem.Add('A senha deve ser informada!');
//      end
//      else if (Length(Trim(FDMPessoa.TPessoasenha.Value)) <= 2) then
//      begin
//        mensagem.Add('A senha deve conter no minimo 2 caracteres validos!');
//      end
//      else if (Length(Trim(FDMPessoa.TPessoasenha.Value)) > 250) then
//      begin
//        mensagem.Add('A senha deve conter no maximo 250 caracteres validos!');
//      end;
//    end
//    else if (FDMPessoa.tipoCadastro = 'funcionario') then
//    begin
//      if not (FDMPessoa.TPessoacodigoFuncao.Value > 0) then
//      begin
//        mensagem.Add('A função deve ser selecionada!');
//      end;
//    end;
//  end;
//
//  if (FDMPessoa.TPessoatipoDocumento.Value = '') then
//  begin
//    mensagem.Add('O Documento deve ser selecionado!');
//  end
//  else if (Trim(soNumeros(FDMPessoa.TPessoadocumento.Value)) = '') then
//  begin
//    mensagem.Add('O Nº do Documento deve ser informado!');
//  end
//  else if (Length(Trim(soNumeros(FDMPessoa.TPessoadocumento.Value))) <> FDMPessoa.TPessoaqtdeCaracteres.Value) then
//  begin
//    mensagem.Add('O Nº do Documento deve conter ' + IntToStrSenaoZero(FDMPessoa.TPessoaqtdeCaracteres.Value) +
//                 ' caracteres validos!');
//  end;

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
