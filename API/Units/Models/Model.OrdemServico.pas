unit Model.OrdemServico;

interface

uses system.SysUtils, Model.Sessao, Model.Pessoa.Endereco, Model.Pessoa,
      ZDataset, System.Classes;

type TOrdemServico = class

  private
    FCodigo: integer;
    FEmpresa: TPessoa;
    FCLiente: TPessoa;
    FEndereco: TEndereco;
    FTransportador: Tpessoa;
    FFinalidade: string;
    FSituacao: string;
    FTipoFrete: string;
    FDetalhamento: string;
    FObservacao: string;
    FDataEntrega: TDate;
    FDataEntregafinal: TDate;
    FDataOrdem: Tdate;
    FDataOrdemFinal: Tdate;
    FDesconto: Double;
    FCadastradoPor: TSessao;
    FAlteradoPor: TSessao;
    FDataCadastro: TDateTime;
    FUltimaAlteracao: TDateTime;
    FStatus: string;
    FLimite: integer;
    FOffset: Integer;
    FRegistrosAfetados: Integer;
    FMaisRegistro: Boolean;

    function contar: integer;
    function montarOrdemServico(query: TZQuery): TOrdemServico;
    function consultarCodigo(codigo: integer): TOrdemServico;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property empresa: TPessoa read FEmpresa write FEmpresa;
    property cliente: TPessoa read FCLiente write FCLiente;
    property endereco: TEndereco read FEndereco write FEndereco;
    property transportador: Tpessoa read FTransportador write FTransportador;
    property finalidade: string read FFinalidade write FFinalidade;
    property situacao: string read FSituacao write FSituacao;
    property tipoFrete: string read FTipoFrete write FTipoFrete;
    property detalhamento: string read FDetalhamento write FDetalhamento;
    property observacao: string read FObservacao write FObservacao;
    property dataEntrega: TDate read FDataEntrega write FDataEntrega;
    property dataEntregaFinal: TDate read FDataEntregaFinal write FDataEntregaFinal;
    property dataOrdem: TDate read FDataOrdem write FDataOrdem;
    property dataOrdemFinal: TDate read FDataOrdemFinal write FDataOrdemFinal;
    property desconto: Double read FDesconto write FDesconto;
    property cadastradoPor: TSessao read FCadastradoPor write FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor write FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao write FUltimaAlteracao;
    property status: string read FStatus write FStatus;
    property maisRegistro: Boolean read FMaisRegistro;
    property offset: Integer read FOffset write FOffset;
    property limite: Integer read FLimite write FLimite;
    property registrosAfetados: Integer read FRegistrosAfetados write FRegistrosAfetados;

    procedure limpar;
    procedure atualizarLog(codigo, status: Integer; resposta: string);

    function consultar: TArray<TOrdemServico>;
    function consultarChave: TOrdemServico;
    function cadastrarOrdemServico: TOrdemServico;
    function alterarOrdemServico: TOrdemServico;
    function inativarOrdemServico: TOrdemServico;
    function verificarToken(token: string): Boolean;
    function GerarLog(classe, procedimento, requisicao: string): integer;
end;

implementation

uses UFuncao, Principal;

{ TOrdemServico }

function TOrdemServico.alterarOrdemServico: TOrdemServico;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico`');
  sql.Add('   SET CODIGO_EMPRESA = ' + IntToStrSenaoZero(FEmpresa.id));
  sql.Add('     , `CODIGO_CLIENTE` = ' + IntToStrSenaoZero(FCLiente.id));
  sql.Add('     , `CODIGO_ENDERECO` = ' + IntToStrSenaoZero(FEndereco.id));
  sql.Add('     , `CODIGO_TRANSPORTADORA` = ' + IntToStrSenaoZero(FTransportador.id));
  sql.Add('     , `FINALIDADE` = ' + QuotedStr(FFinalidade));
  sql.Add('     , `TIPO_FRETE` = ' + QuotedStr(FTipoFrete));
  sql.Add('     , `DETALHAMENTO` = ' + QuotedStr(FDetalhamento));
  sql.Add('     , `OBSERVACAO` = ' + QuotedStr(FObservacao));
  sql.Add('     , `DATA_PRAZO_ENTREGA` = ' + DataBD(FDataEntrega));
  sql.Add('     , `DATA_OS` = ' + DataBD(FDataOrdem));
  sql.Add('     , `DESCONTO` = ' + VirgulaPonto(FDesconto));
  sql.Add('     , `STATUS` = ' + QuotedStr(FStatus));
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TOrdemServico.atualizarLog(codigo, status: Integer; resposta: string);
begin
  FConexao.atualizarLog(codigo, status, resposta);
end;

function TOrdemServico.cadastrarOrdemServico: TOrdemServico;
var
  sql: TStringList;
  codigo: Integer;
begin
  codigo := FConexao.ultimoRegistro('ordem_servico', 'CODIGO_OS');

  sql := TStringList.Create;
  sql.Add('INSERT INTO `ordem_servico` (`CODIGO_OS`, `CODIGO_EMPRESA`, `CODIGO_CLIENTE`, `CODIGO_ENDERECO`');
  sql.Add(', `CODIGO_TRANSPORTADORA`, `FINALIDADE`, `TIPO_FRETE`, `DETALHAMENTO`, `OBSERVACAO`');
  sql.Add(', `DATA_PRAZO_ENTREGA`, `DATA_OS`, `SITUACAO`');
  sql.Add(', `DESCONTO`, `CODIGO_SESSAO_CADASTRO`, `CODIGO_SESSAO_ALTERACAO`) VALUES (');
  sql.Add(' ' + IntToStrSenaoZero(codigo));                                     //CODIGO_OS
  sql.Add(',' + IntToStrSenaoZero(FEmpresa.id));                                //CODIGO_EMPRESA
  sql.Add(',' + IntToStrSenaoZero(Fcliente.id));                                //CODIGO_CLIENTE
  sql.Add(',' + IntToStrSenaoZero(FEndereco.id));                               //CODIGO_ENDERECO
  sql.Add(',' + IntToStrSenaoZero(FTransportador.id));                          //CODIGO_TRANSPORTADORA
  sql.Add(',' + QuotedStr(FFinalidade));                                        //FINALIDADE
  sql.Add(',' + QuotedStr(FTipoFrete));                                         //TIPO_FRETE
  sql.Add(',' + QuotedStr(FDetalhamento));                                      //DETALHAMENTO
  sql.Add(',' + QuotedStr(FObservacao));                                        //OBSERVACAO
  sql.Add(',' + DataBD(FDataEntrega));                                          //DATA_PRAZO_ENTREGA
  sql.Add(',' + DataBD(FDataOrdem));                                            //DATA_OS
  sql.Add(',' + QuotedStr(FSituacao));                                          //SITUACAO
  sql.Add(',' + VirgulaPonto(FDesconto));                                       //DESCONTO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_CADASTRO
  sql.Add(',' + IntToStrSenaoZero(FConexao.codigoSessao));                      //CODIGO_SESSAO_ALTERACAO
  sql.Add(')');

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(codigo);
end;

function TOrdemServico.consultar: TArray<TOrdemServico>;
var
  query: TZQuery;
  ordensServico: TArray<TOrdemServico>;
  contador: Integer;
  sql: TStringList;
  restante: Integer;
begin
  try
    if (FLimite = 0) or(FLimite > 500) then
    begin
      FLimite := 500;
    end;

    restante := contar() - FLimite - FOffset;

    if (restante > 0) then
    begin
      FMaisRegistro := True;
    end
    else
    begin
      FMaisRegistro := False;
    end;

    sql := TStringList.Create;
    sql.Add('SELECT ordem_servico.CODIGO_OS, ordem_servico.CODIGO_EMPRESA, ordem_servico.CODIGO_CLIENTE');
    sql.Add(', ordem_servico.CODIGO_ENDERECO, ordem_servico.CODIGO_TRANSPORTADORA, ordem_servico.FINALIDADE');
    sql.Add(', ordem_servico.TIPO_FRETE, ordem_servico.DETALHAMENTO, ordem_servico.OBSERVACAO');
    sql.Add(', ordem_servico.DATA_PRAZO_ENTREGA, ordem_servico.DATA_OS, ordem_servico.DESCONTO');
    sql.Add(', ordem_servico.CODIGO_SESSAO_CADASTRO, ordem_servico.CODIGO_SESSAO_ALTERACAO');
    sql.Add(', ordem_servico.DATA_CADASTRO, ordem_servico.DATA_ULTIMA_ALTERACAO, ordem_servico.`STATUS`');
    sql.Add(', ordem_servico.SITUACAO');
    sql.Add('');
    sql.Add(', (SELECT pessoa_endereco.CEP');
    sql.Add('     FROM pessoa_endereco, pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE ');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoCep');
    sql.Add('');
    sql.Add(', (SELECT pessoa_endereco.LONGRADOURO');
    sql.Add('     FROM pessoa_endereco, pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoLongradouro');
    sql.Add('');
    sql.Add(', (SELECT pessoa_endereco.NUMERO');
    sql.Add('     FROM pessoa_endereco, pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoNumero');
    sql.Add('');
    sql.Add(', (SELECT pessoa_endereco.BAIRRO');
    sql.Add('     FROM pessoa_endereco, pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoBairro ');
    sql.Add('');
    sql.Add(', (SELECT pessoa_endereco.COMPLEMENTO');
    sql.Add('     FROM pessoa_endereco, pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE ');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoComplemento');
    sql.Add('');
    sql.Add(', (SELECT pessoa_endereco.OBSERVACAO');
    sql.Add('     FROM pessoa_endereco, pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoObservacao');
    sql.Add('');
    sql.Add(', (SELECT cidade.NOME');
    sql.Add('     FROM pessoa_endereco, pessoa, cidade ');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA ');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('		   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE) enderecoCidade');
    sql.Add('');
    sql.Add(', (SELECT estado.NOME');
    sql.Add('     FROM pessoa_endereco, pessoa, cidade, estado');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA');
    sql.Add('		   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('		   AND cidade.CODIGO_ESTADO = estado.CODIGO_ESTADO) enderecoEstado');
    sql.Add('');
    sql.Add(', (SELECT pais.NOME');
    sql.Add('     FROM pessoa_endereco, pessoa, cidade, estado, pais');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA');
    sql.Add('		   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE');
    sql.Add('		   AND cidade.CODIGO_ESTADO = estado.CODIGO_ESTADO');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('		   AND estado.CODIGO_PAIS = pais.CODIGO_PAIS) enderecoPais');
    sql.Add('');
    sql.Add(', (SELECT tipo_endereco.DESCRICAO ');
    sql.Add('     FROM pessoa_endereco, pessoa, tipo_endereco');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
    sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA');
    sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
    sql.Add('		   AND pessoa_endereco.CODIGO_TIPO_ENDERECO = tipo_endereco.CODIGO_TIPO_ENDERECO) enderecoTipo');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_EMPRESA) empresa');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE) cliente');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_TRANSPORTADORA) transportadora');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('     AND sessao.CODIGO_SESSAO = ordem_servico.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
    sql.Add('');
    sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
    sql.Add('     FROM pessoa, sessao');
    sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
    sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
    sql.Add('');
    sql.Add('	FROM ordem_servico');
    sql.Add(' WHERE ordem_servico.`STATUS` = ' + QuotedStr(FStatus));

    if  (FCodigo > 0) then
    begin
      sql.Add('   AND ordem_servico.CODIGO_OS = ' + IntToStrSenaoZero(FCodigo));
    end;

    if (FFinalidade <> '') then
    begin
      sql.Add('   AND ordem_servico.FINALIDADE LIKE ' + QuotedStr('%' + FFinalidade + '%'));
    end;

    if (FSituacao <> '') then
    begin
      sql.Add('   AND ordem_servico.SITUACAO = ' + QuotedStr(FSituacao));
    end;

    if (FEmpresa.id > 0) then
    begin
      sql.Add('   AND ordem_servico.CODIGO_EMPRESA = ' + IntToStrSenaoZero(FEmpresa.id));
    end;

    if (FCLiente.id > 0) then
    begin
      sql.Add('   AND ordem_servico.CODIGO_CLIENTE = ' + IntToStrSenaoZero(FCLiente.id));
    end;

    if (FEndereco.id > 0) then
    begin
      sql.Add('   AND ordem_servico.CODIGO_ENDERECO = ' + IntToStrSenaoZero(FEndereco.id));
    end;

    if (FTransportador.id > 0) then
    begin
      sql.Add('   AND ordem_servico.CODIGO_TRANSPORTADORA = ' + IntToStrSenaoZero(FTransportador.id));
    end;

    if (FTipoFrete <> '') then
    begin
      sql.Add('   AND ordem_servico.TIPO_FRETE LIKE ' + QuotedStr('%' + FTipoFrete + '%'));
    end;

    if (FDetalhamento <> '') then
    begin
      sql.Add('   AND ordem_servico.DETALHAMENTO LIKE ' + QuotedStr('%' + FDetalhamento + '%'));
    end;

    if (FObservacao <> '') then
    begin
      sql.Add('   AND ordem_servico.OBSERVACAO LIKE ' + QuotedStr('%' + FObservacao + '%'));
    end;

    if (FDataEntrega > StrToDate('31/12/1989')) and (FDataEntregafinal > StrToDate('31/12/1989')) then
    begin
      sql.Add('   AND ordem_servico.DATA_PRAZO_ENTREGA >= ' + DataBD(FDataEntrega));
      sql.Add('   AND ordem_servico.DATA_PRAZO_ENTREGA <= ' + DataBD(FDataEntregafinal));
    end;

    if (FDataOrdem > StrToDate('31/12/1989')) and (FDataOrdemFinal > StrToDate('31/12/1989')) then
    begin
      sql.Add('   AND ordem_servico.DATA_OS >= ' + DataBD(FDataOrdem));
      sql.Add('   AND ordem_servico.DATA_OS <= ' + DataBD(FDataEntregafinal));
    end;

    sql.Add(' LIMIT ' + IntToStrSenaoZero(FOffset) + ', ' + IntToStrSenaoZero(FLimite));

    query := FConexao.executarComandoDQL(sql.Text);

    if not Assigned(query)
    or (query = nil)
    or (query.RecordCount = 0) then
    begin
      Result := [];
    end
    else
    begin
      query.First;
      FRegistrosAfetados := FConexao.registrosAfetados;
      SetLength(ordensServico, query.RecordCount);
      contador := 0;

      while not query.Eof do
      begin
        ordensServico[contador] := montarOrdemServico(query);
        query.Next;
        inc(contador);
      end;

      Result := ordensServico;
    end;

    FreeAndNil(sql);
  except
    on E: Exception do
    begin
      raise Exception.Create(e.Message);
      Result := nil;
      FreeAndNil(sql);
    end;
  end;
end;

function TOrdemServico.consultarChave: TOrdemServico;
var
  query: TZQuery;
  ordemConsultado: TOrdemServico;
  sql: TStringList;
begin
  ordemConsultado := TOrdemServico.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_OS, SITUACAO');
  sql.Add('  FROM ordem_servico');
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    ordemConsultado.Destroy;
    ordemConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;

    ordemConsultado.FCodigo := query.FieldByName('CODIGO_OS').Value;
    ordemConsultado.FSituacao := query.FieldByName('SITUACAO').Value;
  end;

  Result := ordemConsultado;

  FreeAndNil(sql);
end;

function TOrdemServico.consultarCodigo(codigo: integer): TOrdemServico;
var
  query: TZQuery;
  sql: TStringList;
  ordemConsultado: TOrdemServico;
begin
  sql := TStringList.Create;
  sql.Add('SELECT ordem_servico.CODIGO_OS, ordem_servico.CODIGO_EMPRESA, ordem_servico.CODIGO_CLIENTE');
  sql.Add(', ordem_servico.CODIGO_ENDERECO, ordem_servico.CODIGO_TRANSPORTADORA, ordem_servico.FINALIDADE');
  sql.Add(', ordem_servico.TIPO_FRETE, ordem_servico.DETALHAMENTO, ordem_servico.OBSERVACAO');
  sql.Add(', ordem_servico.DATA_PRAZO_ENTREGA, ordem_servico.DATA_OS, ordem_servico.DESCONTO');
  sql.Add(', ordem_servico.CODIGO_SESSAO_CADASTRO, ordem_servico.CODIGO_SESSAO_ALTERACAO');
  sql.Add(', ordem_servico.DATA_CADASTRO, ordem_servico.DATA_ULTIMA_ALTERACAO, ordem_servico.`STATUS`');
  sql.Add(', ordem_servico.SITUACAO');
  sql.Add('');
  sql.Add(', (SELECT pessoa_endereco.CEP');
  sql.Add('     FROM pessoa_endereco, pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE ');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoCep');
  sql.Add('');
  sql.Add(', (SELECT pessoa_endereco.LONGRADOURO');
  sql.Add('     FROM pessoa_endereco, pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoLongradouro');
  sql.Add('');
  sql.Add(', (SELECT pessoa_endereco.NUMERO');
  sql.Add('     FROM pessoa_endereco, pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoNumero');
  sql.Add('');
  sql.Add(', (SELECT pessoa_endereco.BAIRRO');
  sql.Add('     FROM pessoa_endereco, pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoBairro ');
  sql.Add('');
  sql.Add(', (SELECT pessoa_endereco.COMPLEMENTO');
  sql.Add('     FROM pessoa_endereco, pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE ');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoComplemento');
  sql.Add('');
  sql.Add(', (SELECT pessoa_endereco.OBSERVACAO');
  sql.Add('     FROM pessoa_endereco, pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA) enderecoObservacao');
  sql.Add('');
  sql.Add(', (SELECT cidade.NOME');
  sql.Add('     FROM pessoa_endereco, pessoa, cidade ');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA ');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('		   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE) enderecoCidade');
  sql.Add('');
  sql.Add(', (SELECT estado.NOME');
  sql.Add('     FROM pessoa_endereco, pessoa, cidade, estado');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA');
  sql.Add('		   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('		   AND cidade.CODIGO_ESTADO = estado.CODIGO_ESTADO) enderecoEstado');
  sql.Add('');
  sql.Add(', (SELECT pais.NOME');
  sql.Add('     FROM pessoa_endereco, pessoa, cidade, estado, pais');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA');
  sql.Add('		   AND pessoa_endereco.CODIGO_CIDADE = cidade.CODIGO_CIDADE');
  sql.Add('		   AND cidade.CODIGO_ESTADO = estado.CODIGO_ESTADO');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('		   AND estado.CODIGO_PAIS = pais.CODIGO_PAIS) enderecoPais');
  sql.Add('');
  sql.Add(', (SELECT tipo_endereco.DESCRICAO ');
  sql.Add('     FROM pessoa_endereco, pessoa, tipo_endereco');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE');
  sql.Add('	     AND pessoa.CODIGO_PESSOA = pessoa_endereco.CODIGO_PESSOA');
  sql.Add('      AND pessoa_endereco.CODIGO_ENDERECO = ordem_servico.CODIGO_ENDERECO');
  sql.Add('		   AND pessoa_endereco.CODIGO_TIPO_ENDERECO = tipo_endereco.CODIGO_TIPO_ENDERECO) enderecoTipo');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_EMPRESA) empresa');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_CLIENTE) cliente');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = ordem_servico.CODIGO_TRANSPORTADORA) transportadora');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('     AND sessao.CODIGO_SESSAO = ordem_servico.CODIGO_SESSAO_CADASTRO) usuarioCadastro');
  sql.Add('');
  sql.Add(', (SELECT pessoa.RAZAO_SOCIAL');
  sql.Add('     FROM pessoa, sessao');
  sql.Add('    WHERE pessoa.CODIGO_PESSOA = sessao.CODIGO_PESSOA');
  sql.Add('      AND sessao.CODIGO_SESSAO = ordem_servico.CODIGO_SESSAO_ALTERACAO) usuarioAlteracao');
  sql.Add('');
  sql.Add('	FROM ordem_servico');
  sql.Add(' WHERE ordem_servico.CODIGO_OS = ' + IntToStrSenaoZero(codigo));

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    ordemConsultado := nil;
  end
  else
  begin
    query.First;
    FRegistrosAfetados := FConexao.registrosAfetados;
    ordemConsultado := montarOrdemServico(query);
  end;

  Result := ordemConsultado;
  FreeAndNil(sql);
end;

function TOrdemServico.contar: integer;
var
  query: TZQuery;
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('SELECT COUNT(ordem_servico.CODIGO_OS) TOTAL');
  sql.Add('  FROM ordem_servico');
  sql.Add(' WHERE ordem_servico.`STATUS` = ' + QuotedStr(FStatus));

  if  (FCodigo > 0) then
  begin
    sql.Add('   AND ordem_servico.CODIGO_OS = ' + IntToStrSenaoZero(FCodigo));
  end;

  if (FFinalidade <> '') then
  begin
    sql.Add('   AND ordem_servico.FINALIDADE LIKE ' + QuotedStr('%' + FFinalidade + '%'));
  end;

  if (FFinalidade <> '') then
  begin
    sql.Add('   AND ordem_servico.SITUACAO IN(' + QuotedStr(FFinalidade) + ')');
  end;

  if (FEmpresa.id > 0) then
  begin
    sql.Add('   AND ordem_servico.CODIGO_EMPRESA = ' + IntToStrSenaoZero(FEmpresa.id));
  end;

  if (FCLiente.id > 0) then
  begin
    sql.Add('   AND ordem_servico.CODIGO_CLIENTE = ' + IntToStrSenaoZero(FCLiente.id));
  end;

  if (FEndereco.id > 0) then
  begin
    sql.Add('   AND ordem_servico.CODIGO_ENDERECO = ' + IntToStrSenaoZero(FEndereco.id));
  end;

  if (FTransportador.id > 0) then
  begin
    sql.Add('   AND ordem_servico.CODIGO_TRANSPORTADORA = ' + IntToStrSenaoZero(FTransportador.id));
  end;

  if (FTipoFrete <> '') then
  begin
    sql.Add('   AND ordem_servico.TIPO_FRETE LIKE ' + QuotedStr('%' + FTipoFrete + '%'));
  end;

  if (FDetalhamento <> '') then
  begin
    sql.Add('   AND ordem_servico.DETALHAMENTO LIKE ' + QuotedStr('%' + FDetalhamento + '%'));
  end;

  if (FObservacao <> '') then
  begin
    sql.Add('   AND ordem_servico.OBSERVACAO LIKE ' + QuotedStr('%' + FObservacao + '%'));
  end;

  if (FDataEntrega > 0) and (FDataEntregafinal > 0) then
  begin
    sql.Add('   AND ordem_servico.DATA_PRAZO_ENTREGA >= ' + DataBD(FDataEntrega));
    sql.Add('   AND ordem_servico.DATA_PRAZO_ENTREGA <= ' + DataBD(FDataEntregafinal));
  end;

  if (FDataOrdem > 0) and (FDataOrdemFinal > 0) then
  begin
    sql.Add('   AND ordem_servico.DATA_OS >= ' + DataBD(FDataOrdem));
    sql.Add('   AND ordem_servico.DATA_OS <= ' + DataBD(FDataEntregafinal));
  end;

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    Result := 0;
  end
  else
  begin
    Result := query.FieldByName('TOTAL').Value;
  end;

  FreeAndNil(sql);
end;

constructor TOrdemServico.Create;
begin
  FCadastradoPor := TSessao.Create;
  FAlteradoPor := TSessao.Create;
  FEmpresa := TPessoa.Create;
  FCLiente := TPessoa.Create;
  FEndereco := TEndereco.Create;
  FTransportador := TPessoa.Create;

  inherited;
end;

destructor TOrdemServico.Destroy;
begin
  if Assigned(FCadastradoPor) then
  begin
    FCadastradoPor.Destroy;
  end;

  if Assigned(FAlteradoPor) then
  begin
    FAlteradoPor.Destroy;
  end;

  if Assigned(FEmpresa) then
  begin
    FEmpresa.Destroy;
  end;

  if Assigned(FCLiente) then
  begin
    FCLiente.Destroy;
  end;

  if Assigned(FEndereco) then
  begin
    FEndereco.Destroy;
  end;

  if Assigned(FTransportador) then
  begin
    FTransportador.Destroy;
  end;

  inherited;
end;

function TOrdemServico.GerarLog(classe, procedimento,
  requisicao: string): integer;
begin
  Result := FConexao.GerarLog(classe, procedimento, requisicao);
end;

function TOrdemServico.inativarOrdemServico: TOrdemServico;
var
  sql: TStringList;
begin
  sql := TStringList.Create;
  sql.Add('UPDATE `ordem_servico`');
  sql.Add('   SET `STATUS` = ''I'' ');
  sql.Add('     , CODIGO_SESSAO_ALTERACAO = ' + IntToStrSenaoZero(FConexao.codigoSessao));
  sql.Add(' WHERE CODIGO_OS = ' + IntToStrSenaoZero(FCodigo));

  FConexao.executarComandoDML(sql.Text);
  FreeAndNil(sql);
  Result := consultarCodigo(FCodigo);
end;

procedure TOrdemServico.limpar;
begin
  FCodigo := 0;
  FEmpresa.limpar;
  FCLiente.limpar;
  FEndereco.limpar;
  FTransportador.limpar;
  FFinalidade := '';
  FSituacao := '';
  FTipoFrete := 'CIF';
  FDetalhamento := '';
  FObservacao := '';
  FDataEntrega := 0;
  FDataEntregafinal := 0;
  FDataOrdem := 0;
  FDataOrdemFinal := 0;
  FDesconto := 0;
  FCadastradoPor.limpar;
  FAlteradoPor.limpar;
  FDataCadastro := Now;
  FUltimaAlteracao := Now;
  FStatus := 'A';
  FLimite := 0;
  FOffset := 0;
  FRegistrosAfetados := 0;
  FMaisRegistro := False;
end;

function TOrdemServico.montarOrdemServico(query: TZQuery): TOrdemServico;
var
  data: TOrdemServico;
begin
  try
    data := TOrdemServico.Create;

    data.FCodigo := query.FieldByName('CODIGO_OS').Value;
    data.FEmpresa.id := query.FieldByName('CODIGO_EMPRESA').Value;
    data.FCLiente.id := query.FieldByName('CODIGO_CLIENTE').Value;
    data.FEndereco.id := query.FieldByName('CODIGO_ENDERECO').Value;
    data.FTransportador.id := query.FieldByName('CODIGO_TRANSPORTADORA').Value;
    data.FFinalidade := query.FieldByName('FINALIDADE').Value;
    data.FSituacao := query.FieldByName('SITUACAO').Value;
    data.FTipoFrete := query.FieldByName('TIPO_FRETE').Value;
    data.FDetalhamento := query.FieldByName('DETALHAMENTO').Value;
    data.observacao := query.FieldByName('OBSERVACAO').Value;
    data.FDataEntrega := query.FieldByName('DATA_PRAZO_ENTREGA').Value;
    data.FDataOrdem := query.FieldByName('DATA_OS').Value;
    data.FDesconto := query.FieldByName('DESCONTO').Value;
    data.FEndereco.cep := query.FieldByName('enderecoCep').Value;
    data.FEndereco.longradouro := query.FieldByName('enderecoLongradouro').Value;
    data.FEndereco.numero := query.FieldByName('enderecoNumero').Value;
    data.FEndereco.bairro := query.FieldByName('enderecoBairro').Value;
    data.FEndereco.complemento := query.FieldByName('enderecoComplemento').Value;
    data.FEndereco.observacao := query.FieldByName('enderecoObservacao').Value;
    data.FEndereco.cidade.nome := query.FieldByName('enderecoCidade').Value;
    data.FEndereco.cidade.estado.nome := query.FieldByName('enderecoEstado').Value;
    data.FEndereco.cidade.estado.pais.nome := query.FieldByName('enderecoPais').Value;
    data.FEndereco.tipoEndereco.descricao := query.FieldByName('enderecoTipo').Value;
    data.FEmpresa.razaoSocial := query.FieldByName('empresa').Value;
    data.FCLiente.razaoSocial := query.FieldByName('cliente').Value;
    data.FTransportador.razaoSocial := query.FieldByName('transportadora').Value;
    data.FCadastradoPor.usuario := query.FieldByName('usuarioCadastro').Value;
    data.FAlteradoPor.usuario := query.FieldByName('usuarioAlteracao').Value;
    data.FDataCadastro := query.FieldByName('DATA_CADASTRO').Value;
    data.FUltimaAlteracao := query.FieldByName('DATA_ULTIMA_ALTERACAO').Value;
    data.FStatus := query.FieldByName('STATUS').Value;

    Result := data;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao montar Ordem de Serviço ' + e.Message);
      Result := nil;
    end;
  end;
end;

function TOrdemServico.verificarToken(token: string): Boolean;
begin
  Result := FConexao.verificarToken(token);
end;

end.
