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
    PCDados: TPageControl;
    TBItem: TTabSheet;
    Panel2: TPanel;
    BCadastrarItem: TSpeedButton;
    BRemoverItem: TSpeedButton;
    TBProduto: TTabSheet;
    PDados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ECodigo: TDBEdit;
    DBLEmpresa: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    BCadastrarProduto: TSpeedButton;
    BExcluirProduto: TSpeedButton;
    CBInativoProduto: TCheckBox;
    GProduto: TDBGrid;
    GItem: TDBGrid;
    Label13: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBCliente: TDBEdit;
    Label8: TLabel;
    DBMemo2: TDBMemo;
    Label9: TLabel;
    DBEdit2: TDBEdit;
    DBEndereco: TDBEdit;
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
    DBTransportadora: TDBEdit;
    Label23: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    DBEdit14: TDBEdit;
    Label24: TLabel;
    Label25: TLabel;
    DBPrazoEntrega: TDateTimePicker;
    Label26: TLabel;
    DBDataOrdem: TDateTimePicker;
    Label17: TLabel;
    DBLConsultaEmpresa: TDBLookupComboBox;
    CBMostrarInativoItem: TCheckBox;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    DBEdit3: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    TabResumo: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ECadastradoPor: TDBEdit;
    EAlteradoPor: TDBEdit;
    EDataCadastro: TDBEdit;
    Label7: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
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
    procedure DBLConsultaEmpresaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBDataOrdemChange(Sender: TObject);
    procedure DBPrazoEntregaChange(Sender: TObject);
    procedure DBClienteDblClick(Sender: TObject);
    procedure DBClienteExit(Sender: TObject);
    procedure BInativarClick(Sender: TObject);
    procedure DBEnderecoDblClick(Sender: TObject);
    procedure DBTransportadoraDblClick(Sender: TObject);
    procedure DBTransportadoraExit(Sender: TObject);
    procedure BRemoverItemClick(Sender: TObject);
    procedure BExcluirProdutoClick(Sender: TObject);
    procedure BCadastrarItemClick(Sender: TObject);
    procedure BCadastrarProdutoClick(Sender: TObject);
    procedure GItemDblClick(Sender: TObject);
    procedure GProdutoDblClick(Sender: TObject);
    procedure CBInativoProdutoClick(Sender: TObject);
    procedure CBMostrarInativoItemClick(Sender: TObject);
    procedure TabResumoShow(Sender: TObject);
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

uses UFuncao, DMOrdemServico, DMPessoa, SelecaoEnderecoCliente,
     OrdemServicoProduto, OrdemServicoItem;

{$R *.dfm}

procedure TFOrdemServico.BAlterarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else
  begin
    UFuncao.desativaBotoes(self);
    BCancelar.Enabled := False;
    FDMOrdemServico.TOrdemServico.Edit;
  end;
end;

procedure TFOrdemServico.BCadastrarClick(Sender: TObject);
begin
  UFuncao.desativaBotoes(self);
  FDMOrdemServico.TOrdemServico.Append;
  DBDataOrdemChange(nil);
  DBPrazoEntregaChange(nil);
  FDMOrdemServico.TOrdemServicosituacao.Value := 'ORÇAMENTO';

  if (FDMOrdemServico.QEmpresa.RecordCount = 1) then
  begin
    DBLEmpresa.KeyValue := FDMOrdemServico.QEmpresacodigo.Value;
    FDMOrdemServico.TOrdemServicoempresaCodigo.Value := FDMOrdemServico.QEmpresacodigo.Value;
  end;
end;

procedure TFOrdemServico.BCadastrarItemClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServicocodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFOrdemServicoItem, FOrdemServicoItem);

    with FDMOrdemServico do
    begin
      TItem.Append;
      TItemordem.Value := TOrdemServicocodigo.Value;
    end;

    FOrdemServicoItem.ShowModal;
  finally
    FreeAndNil(FOrdemServicoItem);
  end;
end;

procedure TFOrdemServico.BCadastrarProdutoClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServicocodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFOrdemServicoProduto, FOrdemServicoProduto);

    with FDMOrdemServico do
    begin
      TProduto.Append;
      TProdutoordem.Value := TOrdemServicocodigo.Value;
    end;

    FOrdemServicoProduto.ShowModal;
  finally
    FreeAndNil(FOrdemServicoProduto);
  end;
end;

procedure TFOrdemServico.BCancelarClick(Sender: TObject);
begin
  CBInativoProduto.Checked := False;
  CBMostrarInativoItem.Checked := False;

  CBInativoProdutoClick(nil);
  CBMostrarInativoItemClick(nil);

  if (FDMOrdemServico.TOrdemServico.State = dsInsert) and
     (FDMOrdemServico.TOrdemServicocodigo.Value > 0) and
     ((FDMOrdemServico.TItem.RecordCount <= 0) and
      (FDMOrdemServico.TProduto.RecordCount <= 0)) and
     (FDMOrdemServico.excluirOrdem = False) then
  begin
    informar('Erro ao cancelar cadastro, contate o suporte!');
  end;

  Painel.SetFocus;
  FDMOrdemServico.TOrdemServico.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFOrdemServico.BConfirmarClick(Sender: TObject);
begin
  confirmarCadastro(True);
end;

procedure TFOrdemServico.BConsultarClick(Sender: TObject);
begin
  BConsultar.Enabled := False;

  try
    FDMOrdemServico.consultarDados(0);
  finally
    BConsultar.Enabled := True;
  end;
end;

procedure TFOrdemServico.BExcluirProdutoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMOrdemServico do
  begin
    if not (TProduto.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (confirmar('Realmente deseja inativar o serviço: ' + TProdutodescricao.Value + '?')) then
    begin
      codigo := TProdutocodigo.Value;

      if (inativarProduto) then
      begin
        consultarDadosProduto(0, True);
        TProduto.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end;
  end;
end;

procedure TFOrdemServico.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFOrdemServico.BInativarClick(Sender: TObject);
begin
//  vai ser o excluir ordem de servico
end;

procedure TFOrdemServico.BRemoverItemClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMOrdemServico do
  begin
    if not (TItem.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (confirmar('Realmente deseja inativar o serviço: ' + TItemdescricao.Value + '?')) then
    begin
      codigo := TItemcodigo.Value;

      if (inativarItem) then
      begin
        consultarDadosItem(0, True);
        TItem.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end;
  end;
end;

procedure TFOrdemServico.CBInativoProdutoClick(Sender: TObject);
begin
  FDMOrdemServico.consultarDadosProduto(0, False);
end;

procedure TFOrdemServico.CBMostrarInativoItemClick(Sender: TObject);
begin
  FDMOrdemServico.consultarDadosItem(0, False);
end;

function TFOrdemServico.confirmarCadastro(confirmar: boolean): Boolean;
var
  resposta: Boolean;
  mensagem: string;
begin
  Painel.SetFocus;
  resposta := False;
  DBDataOrdemChange(nil);
  DBPrazoEntregaChange(nil);

  if (validarCampos) then
  begin
    if (FDMOrdemServico.TOrdemServico.State = dsInsert) and
       (FDMOrdemServico.TOrdemServicocodigo.Value <= 0) then
    begin
      resposta := FDMOrdemServico.cadastrarOrdemServico;
    end
    else if (FDMOrdemServico.TOrdemServico.State = dsEdit) or
       (FDMOrdemServico.TOrdemServicocodigo.Value > 0) then
    begin
      resposta := FDMOrdemServico.alterarOrdemServico;
    end;

    if (FDMOrdemServico.TOrdemServico.State = dsInsert) and
       (confirmar) and
       ((FDMOrdemServico.TItem.RecordCount <= 0) and
        (FDMOrdemServico.TProduto.RecordCount <= 0)) then
    begin
      informar('Insira pelo menos um serviço ou produto!');
    end
    else if (resposta) and (confirmar) then
    begin
      FDMOrdemServico.TOrdemServico.Post;
      UFuncao.desativaBotoes(self);
    end;
  end;

  Result := resposta;
end;

procedure TFOrdemServico.DBClienteDblClick(Sender: TObject);
begin
  UFuncao.abreTelaCliente(True);
  if (FDMPessoa.TPessoa.RecordCount > 0) then
  begin
    FDMOrdemServico.TOrdemServicoclienteCodigo.Value := FDMPessoa.TPessoacodigo.Value;
    FDMOrdemServico.TOrdemServicoclienteNome.Value := FDMPessoa.TPessoarazaoSocial.Value;
  end;
end;

procedure TFOrdemServico.DBClienteExit(Sender: TObject);
begin
  if (FDMOrdemServico.TOrdemServicoclienteCodigo.Value > 0) then
  begin
    FDMPessoa.tipoCadastro := 'cliente';
    FDMPessoa.consultarDados(FDMOrdemServico.TOrdemServicoclienteCodigo.Value);

    if (FDMPessoa.TPessoa.RecordCount > 0) then
    begin
      FDMOrdemServico.TOrdemServicoclienteCodigo.Value := FDMPessoa.TPessoacodigo.Value;
      FDMOrdemServico.TOrdemServicoclienteNome.Value := FDMPessoa.TPessoarazaoSocial.Value;

      FDMOrdemServico.consultarEnderecoCliente;

      if (FDMOrdemServico.QEndereco.RecordCount > 0) then
      begin
        FDMOrdemServico.TOrdemServicoenderecoCodigo.Value := FDMOrdemServico.QEnderecocodigo.Value;
        FDMOrdemServico.TOrdemServicoenderecoTipo.Value := FDMOrdemServico.QEnderecotipoEndereco.Value;
        FDMOrdemServico.TOrdemServicoenderecoCEP.Value := FDMOrdemServico.QEnderecocep.Value;
        FDMOrdemServico.TOrdemServicoenderecoLongradouro.Value := FDMOrdemServico.QEnderecolongradouro.Value;
        FDMOrdemServico.TOrdemServicoenderecoNumero.Value := FDMOrdemServico.QEndereconumero.Value;
        FDMOrdemServico.TOrdemServicoenderecoBairro.Value := FDMOrdemServico.QEnderecobairro.Value;
        FDMOrdemServico.TOrdemServicoenderecoComplemento.Value := FDMOrdemServico.QEnderecocomplemento.Value;
        FDMOrdemServico.TOrdemServicoenderecoCidade.Value := FDMOrdemServico.QEndereconomeCidade.Value;
        FDMOrdemServico.TOrdemServicoenderecoEstado.Value := FDMOrdemServico.QEndereconomeEstado.Value;
        FDMOrdemServico.TOrdemServicoenderecoPais.Value := FDMOrdemServico.QEndereconomePais.Value;
      end;
    end
    else
    begin
      FDMOrdemServico.TOrdemServicoclienteCodigo.Value := 0;
      FDMOrdemServico.TOrdemServicoclienteNome.Value := '';
      DBClienteDblClick(nil);
    end;
  end;
end;

procedure TFOrdemServico.DBDataOrdemChange(Sender: TObject);
begin
  FDMOrdemServico.TOrdemServicodataOrdemServico.Value := DateToStr(DBDataOrdem.Date);
end;

procedure TFOrdemServico.DBEnderecoDblClick(Sender: TObject);
begin
  FDMOrdemServico.consultarEnderecoCliente;

  if (FDMOrdemServico.QEndereco.RecordCount > 0) then
  begin
    try
      Application.CreateForm(TFSelecaoEnderecoCliente, FSelecaoEnderecoCliente);

      if (FSelecaoEnderecoCliente.ShowModal = MrOk) then
      begin
        FDMOrdemServico.TOrdemServicoenderecoCodigo.Value := FDMOrdemServico.QEnderecocodigo.Value;
        FDMOrdemServico.TOrdemServicoenderecoTipo.Value := FDMOrdemServico.QEnderecotipoEndereco.Value;
        FDMOrdemServico.TOrdemServicoenderecoCEP.Value := FDMOrdemServico.QEnderecocep.Value;
        FDMOrdemServico.TOrdemServicoenderecoLongradouro.Value := FDMOrdemServico.QEnderecolongradouro.Value;
        FDMOrdemServico.TOrdemServicoenderecoNumero.Value := FDMOrdemServico.QEndereconumero.Value;
        FDMOrdemServico.TOrdemServicoenderecoBairro.Value := FDMOrdemServico.QEnderecobairro.Value;
        FDMOrdemServico.TOrdemServicoenderecoComplemento.Value := FDMOrdemServico.QEnderecocomplemento.Value;
        FDMOrdemServico.TOrdemServicoenderecoCidade.Value := FDMOrdemServico.QEndereconomeCidade.Value;
        FDMOrdemServico.TOrdemServicoenderecoEstado.Value := FDMOrdemServico.QEndereconomeEstado.Value;
        FDMOrdemServico.TOrdemServicoenderecoPais.Value := FDMOrdemServico.QEndereconomePais.Value;
      end;
    finally
      FreeAndNil(FSelecaoEnderecoCliente);
    end;
  end
  else
  begin
    informar('Esse cliente não possui nenhum endereço cadastrado, va ate o cadastro do cliente e insirá um endereço!');
  end;
end;

procedure TFOrdemServico.DBLConsultaEmpresaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  limparCampoLookUp(Sender, Key);
end;

procedure TFOrdemServico.DBPrazoEntregaChange(Sender: TObject);
begin
  FDMOrdemServico.TOrdemServicodataPrazoEntrega.Value := DateToStr(DBPrazoEntrega.Date);
end;

procedure TFOrdemServico.DBTransportadoraDblClick(Sender: TObject);
begin
  UFuncao.abreTelaFornecedor(True);
  if (FDMPessoa.TPessoa.RecordCount > 0) then
  begin
    FDMOrdemServico.TOrdemServicotransportadoraCodigo.Value := FDMPessoa.TPessoacodigo.Value;
    FDMOrdemServico.TOrdemServicotransportadoraNome.Value := FDMPessoa.TPessoarazaoSocial.Value;
  end;
end;

procedure TFOrdemServico.DBTransportadoraExit(Sender: TObject);
begin
  if (FDMOrdemServico.TOrdemServicotransportadoraCodigo.Value > 0) then
  begin
    FDMPessoa.tipoCadastro := 'fornecedor';
    FDMPessoa.consultarDados(FDMOrdemServico.TOrdemServicotransportadoraCodigo.Value);

    if (FDMPessoa.TPessoa.RecordCount > 0) then
    begin
      FDMOrdemServico.TOrdemServicotransportadoraCodigo.Value := FDMPessoa.TPessoacodigo.Value;
      FDMOrdemServico.TOrdemServicotransportadoraNome.Value := FDMPessoa.TPessoarazaoSocial.Value;
    end
    else
    begin
      FDMOrdemServico.TOrdemServicotransportadoraCodigo.Value := 0;
      FDMOrdemServico.TOrdemServicotransportadoraNome.Value := '';
      DBTransportadoraDblClick(nil);
    end;
  end;
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
  PCTela.ActivePage := TBConsulta;
  PCDados.ActivePage := TBItem;
  FDMOrdemServico.consultarEmpresa;
  BConsultarClick(nil);
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

procedure TFOrdemServico.GItemDblClick(Sender: TObject);
begin
  if (FDMOrdemServico.TItem.RecordCount > 0) then
  try
    Application.CreateForm(TFOrdemServicoItem, FOrdemServicoItem);
    FDMOrdemServico.TItem.Edit;
    FOrdemServicoItem.ShowModal;
  finally
    FreeAndNil(FOrdemServicoItem);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
end;

procedure TFOrdemServico.GProdutoDblClick(Sender: TObject);
begin
  if (FDMOrdemServico.TProduto.RecordCount > 0) then
  try
    Application.CreateForm(TFOrdemServicoProduto, FOrdemServicoProduto);
    FDMOrdemServico.TProduto.Edit;
    FOrdemServicoProduto.ShowModal;
  finally
    FreeAndNil(FOrdemServicoProduto);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
end;

procedure TFOrdemServico.TabResumoShow(Sender: TObject);
var
  valorTotal, desconto, valorFinal: Double;
begin
  if (FDMOrdemServico.TOrdemServico.State in[dsInsert, dsEdit]) then
  begin
    CBInativoProduto.Checked := False;
    CBMostrarInativoItem.Checked := False;

    CBInativoProdutoClick(nil);
    CBMostrarInativoItemClick(nil);

    valorTotal := 0;
    desconto := 0;
    valorFinal := 0;

    FDMOrdemServico.TItem.First;
    while not FDMOrdemServico.TItem.Eof do
    begin
      valorTotal := valorTotal + FDMOrdemServico.TItemvalorTotal.Value;
      desconto := desconto + FDMOrdemServico.TItemvalorDesconto.Value;
      valorFinal := valorFinal + FDMOrdemServico.TItemvalorFinal.Value;
      FDMOrdemServico.TItem.Next;
    end;

    FDMOrdemServico.TOrdemServicovalorTotalItem.Value := valorTotal;
    FDMOrdemServico.TOrdemServicovalorDescontoItem.Value := desconto;
    FDMOrdemServico.TOrdemServicovalorFinalItem.Value := valorFinal;
    valorTotal := 0;
    desconto := 0;
    valorFinal := 0;

    FDMOrdemServico.TProduto.First;
    while not FDMOrdemServico.TProduto.Eof do
    begin
      valorTotal := valorTotal + FDMOrdemServico.TProdutovalorTotal.Value;
      desconto := desconto + FDMOrdemServico.TProdutovalorDesconto.Value;
      valorFinal := valorFinal + FDMOrdemServico.TProdutovalorFinal.Value;
      FDMOrdemServico.TProduto.Next;
    end;

    FDMOrdemServico.TOrdemServicovalorTotalProduto.Value := valorTotal;
    FDMOrdemServico.TOrdemServicovalorDescontoProduto.Value := desconto;
    FDMOrdemServico.TOrdemServicovalorFinalProduto.Value := valorFinal;

    FDMOrdemServico.TOrdemServicovalorTotal.Value := FDMOrdemServico.TOrdemServicovalorTotalProduto.Value +
                                                     FDMOrdemServico.TOrdemServicovalorTotalItem.Value;

    FDMOrdemServico.TOrdemServicovalorDescontoTotal.Value := FDMOrdemServico.TOrdemServicovalorDescontoItem.Value +
                                                             FDMOrdemServico.TOrdemServicovalorDescontoProduto.Value;

    FDMOrdemServico.TOrdemServicovalorFinal.Value := FDMOrdemServico.TOrdemServicovalorTotal.Value -
                                                     FDMOrdemServico.TOrdemServicovalorDescontoTotal.Value;
  end;
end;

procedure TFOrdemServico.TBCadastroShow(Sender: TObject);
begin
  with FDMOrdemServico do
  begin
    if (TOrdemServico.RecordCount > 0) then
    begin
      FOrdemServico.DBDataOrdem.Date := StrToDate(TOrdemServicodataOrdemServico.Value);
      FOrdemServico.DBPrazoEntrega.Date := StrToDate(TOrdemServicodataPrazoEntrega.Value);
    end;

    with FOrdemServico do
    begin
      if (dadosOrdemConsultados <> TOrdemServicocodigo.Value) then
      begin
        consultarDadosItem(0, False);
        consultarDadosProduto(0, False);
      end;
    end;
  end;
end;

function TFOrdemServico.validarCampos: boolean;
var
  mensagem: TStringList;
begin
  mensagem := TStringList.Create;

  if not (FDMOrdemServico.TOrdemServicoempresaCodigo.Value > 0) then
  begin
    mensagem.Add('A empresa deve ser selecionada!');
  end;

  if not (DBDataOrdem.Date > 0) then
  begin
    mensagem.Add('A data de OS deve ser selecionada!');
  end;

  if not (DBPrazoEntrega.Date > 0) then
  begin
    mensagem.Add('O prazo de entrega deve ser selecionado!');
  end;

  if (FDMOrdemServico.TOrdemServicosituacao.Value = '') then
  begin
    mensagem.Add('A Situação deve ser informada!');
  end;

  if not (FDMOrdemServico.TOrdemServicoclienteCodigo.Value > 0) then
  begin
    mensagem.Add('O cliente deve ser selecionado!');
  end
  else
  begin
    FDMPessoa.tipoCadastro := 'cliente';
    FDMPessoa.consultarDados(FDMOrdemServico.TOrdemServicoclienteCodigo.Value);

    if not (FDMPessoa.TPessoa.RecordCount > 0) then
    begin
      mensagem.Add('Selecione um cliente valido!');
    end;
  end;

  if not (FDMOrdemServico.TOrdemServicoenderecoCodigo.Value > 0) then
  begin
    mensagem.Add('O endereço do serviço deve ser selecionado!');
  end;

  if (FDMOrdemServico.TOrdemServicofinalidade.Value = '') then
  begin
    mensagem.Add('A finalidade deve ser selecionada!');
  end;

  if not (FDMOrdemServico.TOrdemServicotransportadoraCodigo.Value > 0) then
  begin
    mensagem.Add('A transportadora do serviço deve ser selecionada!');
  end;

  if (FDMOrdemServico.TOrdemServicotipoFrete.Value = '') then
  begin
    mensagem.Add('O tipo de frete deve ser selecionado!');
  end;

  if (FDMOrdemServico.TOrdemServicodetalhamento.Value = '') then
  begin
    mensagem.Add('O detalhamento da OS deve ser informado!');
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
