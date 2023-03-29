unit OrdemServico;

interface

uses Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Controls, Vcl.Buttons, System.Classes, Vcl.ExtCtrls, System.SysUtils,
  Vcl.Forms, Winapi.Windows, Vcl.ComCtrls, Vcl.Graphics;

type
  TFOrdemServico = class(TForm)
    PCTela: TPageControl;
    TBCadastro: TTabSheet;
    TBConsulta: TTabSheet;
    Panel3: TPanel;
    BConsultar: TSpeedButton;
    LConsultaRazaoSocial: TLabel;
    EDetalhamento: TEdit;
    GDados: TDBGrid;
    CBMostrarInativo: TCheckBox;
    Painel: TPanel;
    BFechar: TSpeedButton;
    BConfirmar: TSpeedButton;
    BCancelar: TSpeedButton;
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
    TabCusto: TTabSheet;
    Panel4: TPanel;
    BCadastrarCusto: TSpeedButton;
    BExcluirCusto: TSpeedButton;
    GCusto: TDBGrid;
    CBInativoCusto: TCheckBox;
    TabCustoFuncionario: TTabSheet;
    Panel5: TPanel;
    BFuncionarioCadastrar: TSpeedButton;
    BFuncionarioExcluir: TSpeedButton;
    GFuncionario: TDBGrid;
    CBInativoFuncionario: TCheckBox;
    Panel7: TPanel;
    GValoresCusto: TDBGrid;
    GValoresOrdem: TDBGrid;
    Panel8: TPanel;
    BImprimir: TSpeedButton;
    BInativar: TSpeedButton;
    Panel6: TPanel;
    BReplicar: TSpeedButton;
    BAprovar: TSpeedButton;
    BFaturar: TSpeedButton;
    BReprovar: TSpeedButton;
    BConcluir: TSpeedButton;
    BExecutar: TSpeedButton;
    BModelo: TSpeedButton;
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
    procedure CBInativoCustoClick(Sender: TObject);
    procedure GCustoDblClick(Sender: TObject);
    procedure BCadastrarCustoClick(Sender: TObject);
    procedure BExcluirCustoClick(Sender: TObject);
    procedure CBInativoFuncionarioClick(Sender: TObject);
    procedure GFuncionarioDblClick(Sender: TObject);
    procedure BFuncionarioCadastrarClick(Sender: TObject);
    procedure BFuncionarioExcluirClick(Sender: TObject);
    procedure BReplicarClick(Sender: TObject);
    procedure GValoresOrdemDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GValoresCustoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BAprovarClick(Sender: TObject);
    procedure BReprovarClick(Sender: TObject);
    procedure BExecutarClick(Sender: TObject);
    procedure BConcluirClick(Sender: TObject);
    procedure BFaturarClick(Sender: TObject);
    procedure BModeloClick(Sender: TObject);
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
     OrdemServicoProduto, OrdemServicoItem, OrdemServicoCusto,
     OrdemServicoFuncionario;

{$R *.dfm}

procedure TFOrdemServico.BAlterarClick(Sender: TObject);
begin
  if (FDMOrdemServico.TOrdemServicosituacao.Value = 'EXCLUIDO') or
     (FDMOrdemServico.TOrdemServicosituacao.Value = 'CONCLUIDO') or
     (FDMOrdemServico.TOrdemServicosituacao.Value = 'FATURADO') or
     (FDMOrdemServico.TOrdemServicosituacao.Value = 'REPROVADO') then
  begin
    informar('A situação ' + FDMOrdemServico.TOrdemServicosituacao.Value + ' não permite que seja alterada a ordem de serviço!');
  end
  else if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
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

procedure TFOrdemServico.BAprovarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value <> 'ORÇAMENTO') then
  begin
    informar('Somente é possivel aprovar ordens de serviço com situação ''ORÇAMENTO''!');
  end
  else if (FDMOrdemServico.aprovarOrdemServico) then
  begin
    informar('Orçamento aprovado com sucesso!');
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

procedure TFOrdemServico.BCadastrarCustoClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServicocodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFOrdemServicoCusto, FOrdemServicoCusto);

    with FDMOrdemServico do
    begin
      TCusto.Append;
      TCustoordem.Value := TOrdemServicocodigo.Value;
    end;

    FOrdemServicoCusto.ShowModal;
  finally
    FreeAndNil(FOrdemServicoCusto);
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
      (FDMOrdemServico.TProduto.RecordCount <= 0) and
      (FDMOrdemServico.TCusto.RecordCount <= 0)) and
     (FDMOrdemServico.excluirOrdem = False) then
  begin
    informar('Erro ao cancelar cadastro, contate o suporte!');
  end;

  Painel.SetFocus;
  FDMOrdemServico.TOrdemServico.Cancel;
  UFuncao.desativaBotoes(self);
end;

procedure TFOrdemServico.BConcluirClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value <> 'EXECUTANDO') then
  begin
    informar('Somente é possivel concluir ordens de serviço com situação ''EXECUTANDO''!');
  end
  else if (confirmar('Realmente deseja concluir essa ordem de serviço?')) and
          (FDMOrdemServico.ConcluirOrdemServico) then
  begin
    informar('Ordem de serviço concluida com sucesso!');
  end;
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

procedure TFOrdemServico.BExcluirCustoClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMOrdemServico do
  begin
    if not (TCusto.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (confirmar('Realmente deseja inativar o custo: ' + TCustodescricao.Value + '?')) then
    begin
      codigo := TCustocodigo.Value;

      if (inativarCusto) then
      begin
        consultarDadosCusto(0, True);
        TCusto.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end;
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

procedure TFOrdemServico.BExecutarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value <> 'APROVADO') then
  begin
    informar('Somente é possivel executar ordens de serviço com situação ''APROVADO''!');
  end
  else if (confirmar('Realmente deseja iniciar essa ordem de serviço?')) and
          (FDMOrdemServico.IniciarOrdemServico) then
  begin
    informar('Ordem de serviço iniciada com sucesso!');
  end;
end;

procedure TFOrdemServico.BFaturarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value <> 'CONCLUIDO') then
  begin
    informar('Somente é possivel faturar ordens de serviço com situação ''CONCLUIDO''!');
  end
  else if (confirmar('Realmente deseja faturar essa ordem de serviço?')) and
          (FDMOrdemServico.FaturarOrdemServico) then
  begin
    informar('Ordem de serviço faturada com sucesso!');
  end;
end;

procedure TFOrdemServico.BFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFOrdemServico.BFuncionarioCadastrarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServicocodigo.Value > 0) and (confirmarCadastro(False) = False) then
  begin
    Exit;
  end;

  try
    Application.CreateForm(TFOrdemServicoFuncionario, FOrdemServicoFuncionario);

    with FDMOrdemServico do
    begin
      TFuncionario.Append;
      TFuncionarioordem.Value := TOrdemServicocodigo.Value;
    end;

    FOrdemServicoFuncionario.ShowModal;
  finally
    FreeAndNil(FOrdemServicoFuncionario);
  end;
end;

procedure TFOrdemServico.BFuncionarioExcluirClick(Sender: TObject);
var
  codigo: integer;
begin
  with FDMOrdemServico do
  begin
    if not (TFuncionario.RecordCount > 0) then
    begin
      informar('Nenhum registro selecionado!');
    end
    else if (confirmar('Realmente deseja inativar o custo de funcionario: ' + TFuncionariodescricao.Value + '?')) then
    begin
      codigo := TFuncionariocodigo.Value;

      if (inativarFuncionario) then
      begin
        consultarDadosFuncionario(0, True);
        TFuncionario.Locate('codigo', codigo, [loCaseInsensitive]);
      end;
    end;
  end;
end;

procedure TFOrdemServico.BInativarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value <> 'ORÇAMENTO') then
  begin
    informar('Somente é possivel excluir ordens de serviço com situação ''ORÇAMENTO''!');
  end
  else if (confirmar('Realmente deseja excluir essa ordem de serviço?')) and
          (FDMOrdemServico.excluirOrdemServico) then
  begin
    informar('Orçamento excluido com sucesso!');
  end;
end;

procedure TFOrdemServico.BModeloClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value <> 'ORÇAMENTO') then
  begin
    informar('Somente é possivel definir como modelo ordens de serviço com situação ''ORÇAMENTO''!');
  end
  else if (confirmar('Realmente deseja definir como modelo essa ordem de serviço?')) and
          (FDMOrdemServico.modeloOrdemServico) then
  begin
    informar('Ordem de serviço definida como modelo com sucesso!');
  end;
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

procedure TFOrdemServico.BReplicarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value = 'REPROVADO') or
          (FDMOrdemServico.TOrdemServicosituacao.Value = 'EXCLUIDO') then
  begin
    informar('Não é possivel replicar ordens de serviço com situação ''REPROVADO'' ou ''EXCLUIDO''!');
  end
  else if (confirmar('Realmente deseja replicar essa ordem de serviço?')) then
  begin
    FDMOrdemServico.replicarOrdem;
  end;
end;

procedure TFOrdemServico.BReprovarClick(Sender: TObject);
begin
  if not (FDMOrdemServico.TOrdemServico.RecordCount > 0) then
  begin
    informar('Nenhum registro selecionado!');
  end
  else if (FDMOrdemServico.TOrdemServicosituacao.Value <> 'ORÇAMENTO') then
  begin
    informar('Somente é possivel reprovar ordens de serviço com situação ''ORÇAMENTO''!');
  end
  else if (confirmar('Realmente deseja reprovar essa ordem de serviço?')) and
          (FDMOrdemServico.reprovarOrdemServico) then
  begin
    informar('Orçamento reprovado com sucesso!');
  end;
end;

procedure TFOrdemServico.CBInativoCustoClick(Sender: TObject);
begin
  FDMOrdemServico.consultarDadosCusto(0, False);
end;

procedure TFOrdemServico.CBInativoFuncionarioClick(Sender: TObject);
begin
  FDMOrdemServico.consultarDadosFuncionario(0, False);
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
      BCancelar.Enabled := False;
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

procedure TFOrdemServico.GCustoDblClick(Sender: TObject);
begin
  if (FDMOrdemServico.TCusto.RecordCount > 0) then
  try
    Application.CreateForm(TFOrdemServicoCusto, FOrdemServicoCusto);
    FDMOrdemServico.TCusto.Edit;
    FOrdemServicoCusto.ShowModal;
  finally
    FreeAndNil(FOrdemServicoCusto);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
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

procedure TFOrdemServico.GFuncionarioDblClick(Sender: TObject);
begin
  if (FDMOrdemServico.TFuncionario.RecordCount > 0) then
  try
    Application.CreateForm(TFOrdemServicoFuncionario, FOrdemServicoFuncionario);
    FDMOrdemServico.TFuncionario.Edit;
    FOrdemServicoFuncionario.ShowModal;
  finally
    FreeAndNil(FOrdemServicoFuncionario);
  end
  else
  begin
    informar('Nenhum registro selecionado!');
  end;
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

procedure TFOrdemServico.GValoresCustoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (FDMOrdemServico.QCustoTotaldescricao.Value = 'Total Custo Geral') or
     (FDMOrdemServico.QCustoTotaldescricao.Value = 'Total Custo Funcionario') or
     (FDMOrdemServico.QCustoTotaldescricao.Value = 'Total Custos') or
     (FDMOrdemServico.QCustoTotaldescricao.Value = 'Lucro/Prejuizo R$') then
  begin
    GValoresCusto.Canvas.Font.Style := GValoresCusto.Canvas.Font.Style + [fsbold];
    GValoresCusto.Canvas.Font.Size := GValoresCusto.Canvas.Font.Size + 1;
    GValoresCusto.Canvas.Brush.Color := clWhite;

    if (FDMOrdemServico.QCustoTotaldescricao.Value = 'Lucro/Prejuizo R$') and
       ((Column.FieldName = 'valorTotal') or
        (Column.FieldName = 'quantidade')) then
    begin
      if (FDMOrdemServico.QCustoTotalvalorTotal.Value > 0) then
      begin
        GValoresCusto.Canvas.Font.Color := clGreen;
      end
      else
      begin
        GValoresCusto.Canvas.Font.Color := clRed;
      end;
    end
    else
    begin
      GValoresCusto.Canvas.Font.Color := clBlack;
    end;
  end
  else if (FDMOrdemServico.QCustoTotaldescricao.Value = '') then
  begin
    GValoresCusto.Canvas.Brush.Color := clWhite;
    GValoresCusto.Canvas.Font.Color := clWhite;
  end
  else if (GValoresCusto.DataSource.DataSet.RecNo mod 2) = 0 then
  begin
    GValoresCusto.Canvas.Brush.Color := clActiveCaption;
    GValoresCusto.Canvas.Font.Color := clBlack;
  end
  else
  begin
    GValoresCusto.Canvas.Brush.Color := clWhite;
    GValoresCusto.Canvas.Font.Color := clBlack;
  end;

  GValoresCusto.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFOrdemServico.GValoresOrdemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (FDMOrdemServico.QValorTotaldescricao.Value = 'Total') then
  begin
    GValoresOrdem.Canvas.Font.Style := GValoresOrdem.Canvas.Font.Style + [fsbold];
    GValoresOrdem.Canvas.Font.Size := GValoresOrdem.Canvas.Font.Size + 1;
    GValoresOrdem.Canvas.Brush.Color := clWhite;
    GValoresOrdem.Canvas.Font.Color := clBlack;
  end
  else if (GValoresOrdem.DataSource.DataSet.RecNo mod 2) = 0 then
  begin
    GValoresOrdem.Canvas.Brush.Color := clActiveCaption;
    GValoresOrdem.Canvas.Font.Color := clBlack;
  end
  else
  begin
    GValoresOrdem.Canvas.Brush.Color := clWhite;
    GValoresOrdem.Canvas.Font.Color := clBlack;
  end;

  GValoresOrdem.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFOrdemServico.TabResumoShow(Sender: TObject);
var
  valorTotal, desconto, valorFinal: Double;
begin
  with FDMOrdemServico do
  begin
    if (TOrdemServico.State in[dsInsert, dsEdit]) then
    begin
      CBInativoProduto.Checked := False;
      CBMostrarInativoItem.Checked := False;
      CBInativoCusto.Checked := False;
      CBInativoFuncionario.Checked := False;

      CBInativoProdutoClick(nil);
      CBMostrarInativoItemClick(nil);
      CBInativoCustoClick(nil);
      CBInativoFuncionarioClick(nil);

      valorTotal := 0;
      desconto := 0;
      valorFinal := 0;

      TItem.First;
      while not TItem.Eof do
      begin
        valorTotal := valorTotal + TItemvalorTotal.Value;
        desconto := desconto + TItemvalorDesconto.Value;
        valorFinal := valorFinal + TItemvalorFinal.Value;
        TItem.Next;
      end;

      TOrdemServicovalorTotalItem.Value := valorTotal;
      TOrdemServicovalorDescontoItem.Value := desconto;
      TOrdemServicovalorFinalItem.Value := valorFinal;
      valorTotal := 0;
      desconto := 0;
      valorFinal := 0;

      TProduto.First;
      while not TProduto.Eof do
      begin
        valorTotal := valorTotal + TProdutovalorTotal.Value;
        desconto := desconto + TProdutovalorDesconto.Value;
        valorFinal := valorFinal + TProdutovalorFinal.Value;
        TProduto.Next;
      end;

      TOrdemServicovalorTotalProduto.Value := valorTotal;
      TOrdemServicovalorDescontoProduto.Value := desconto;
      TOrdemServicovalorFinalProduto.Value := valorFinal;
      valorTotal := 0;

      TCusto.First;
      while not TCusto.Eof do
      begin
        valorTotal := valorTotal + TCustovalorTotal.Value;
        TCusto.Next;
      end;

      TOrdemServicovalorTotalCusto.Value := valorTotal;
      valorTotal := 0;

      TFuncionario.First;
      while not TFuncionario.Eof do
      begin
        valorTotal := valorTotal + TFuncionariovalorTotal.Value;
        TFuncionario.Next;
      end;

      TOrdemServicovalorTotalCustoFuncionario.Value := valorTotal;

      TOrdemServicovalorTotal.Value := TOrdemServicovalorTotalProduto.Value +
                                       TOrdemServicovalorTotalItem.Value;

      TOrdemServicovalorDescontoTotal.Value := TOrdemServicovalorDescontoItem.Value +
                                               TOrdemServicovalorDescontoProduto.Value;

      TOrdemServicovalorFinal.Value := TOrdemServicovalorTotal.Value -
                                       TOrdemServicovalorDescontoTotal.Value;

      TOrdemServicovalorFinalCusto.Value := TOrdemServicovalorTotalCustoFuncionario.Value +
                                            TOrdemServicovalorTotalCusto.Value;

      TOrdemServicovalorLucro.Value := TOrdemServicovalorFinal.Value -
                                       TOrdemServicovalorFinalCusto.Value;

      TOrdemServicovalorLucroPercentual.Value := (TOrdemServicovalorLucro.Value /
                                                  TOrdemServicovalorFinal.Value) * 100;
    end;

    carregarAbaResumo;
  end;
end;

procedure TFOrdemServico.TBCadastroShow(Sender: TObject);
begin
  with FDMOrdemServico do
  begin
    if (TOrdemServico.RecordCount > 0) then
    begin
      DBDataOrdem.Date := StrToDate(TOrdemServicodataOrdemServico.Value);
      DBPrazoEntrega.Date := StrToDate(TOrdemServicodataPrazoEntrega.Value);
    end;

    if (dadosOrdemConsultados <> TOrdemServicocodigo.Value) then
    begin
      consultarDadosItem(0, False);
      consultarDadosProduto(0, False);
      consultarDadosCusto(0, False);
      consultarDadosFuncionario(0, False);
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
