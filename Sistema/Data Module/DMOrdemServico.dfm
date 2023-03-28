object FDMOrdemServico: TFDMOrdemServico
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 343
  Width = 475
  object DOrdemServico: TDataSource
    DataSet = TOrdemServico
    Left = 60
    Top = 67
  end
  object TOrdemServico: TFDMemTable
    AfterScroll = TOrdemServicoAfterScroll
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 59
    Top = 17
    object TOrdemServicocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TOrdemServicoempresaCodigo: TIntegerField
      FieldName = 'empresaCodigo'
    end
    object TOrdemServicoempresaNome: TStringField
      FieldName = 'empresaNome'
      Size = 150
    end
    object TOrdemServicoclienteCodigo: TIntegerField
      FieldName = 'clienteCodigo'
    end
    object TOrdemServicoclienteNome: TStringField
      FieldName = 'clienteNome'
      Size = 150
    end
    object TOrdemServicoenderecoCodigo: TIntegerField
      FieldName = 'enderecoCodigo'
    end
    object TOrdemServicoenderecoTipo: TStringField
      FieldName = 'enderecoTipo'
      Size = 150
    end
    object TOrdemServicoenderecoCEP: TStringField
      FieldName = 'enderecoCEP'
      EditMask = '99999-999;0;'
      Size = 10
    end
    object TOrdemServicoenderecoLongradouro: TStringField
      FieldName = 'enderecoLongradouro'
      Size = 150
    end
    object TOrdemServicoenderecoNumero: TStringField
      FieldName = 'enderecoNumero'
      Size = 10
    end
    object TOrdemServicoenderecoBairro: TStringField
      FieldName = 'enderecoBairro'
      Size = 150
    end
    object TOrdemServicoenderecoComplemento: TStringField
      FieldName = 'enderecoComplemento'
      Size = 150
    end
    object TOrdemServicoenderecoObservacao: TMemoField
      FieldName = 'enderecoObservacao'
      OnGetText = GetText
      BlobType = ftMemo
    end
    object TOrdemServicoenderecoCidade: TStringField
      FieldName = 'enderecoCidade'
      Size = 150
    end
    object TOrdemServicoenderecoEstado: TStringField
      FieldName = 'enderecoEstado'
      Size = 150
    end
    object TOrdemServicoenderecoPais: TStringField
      FieldName = 'enderecoPais'
      Size = 150
    end
    object TOrdemServicotransportadoraCodigo: TIntegerField
      FieldName = 'transportadoraCodigo'
    end
    object TOrdemServicotransportadoraNome: TStringField
      FieldName = 'transportadoraNome'
      Size = 150
    end
    object TOrdemServicofinalidade: TStringField
      FieldName = 'finalidade'
      Size = 50
    end
    object TOrdemServicotipoFrete: TStringField
      FieldName = 'tipoFrete'
      Size = 10
    end
    object TOrdemServicodetalhamento: TMemoField
      FieldName = 'detalhamento'
      OnGetText = GetText
      BlobType = ftMemo
    end
    object TOrdemServicosituacao: TStringField
      FieldName = 'situacao'
      Size = 50
    end
    object TOrdemServicoobservacao: TMemoField
      FieldName = 'observacao'
      OnGetText = GetText
      BlobType = ftMemo
    end
    object TOrdemServicodataPrazoEntrega: TStringField
      FieldName = 'dataPrazoEntrega'
      Size = 10
    end
    object TOrdemServicodataOrdemServico: TStringField
      FieldName = 'dataOrdemServico'
      Size = 10
    end
    object TOrdemServicodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TOrdemServicodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TOrdemServicoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TOrdemServicocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TOrdemServicostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TOrdemServicovalorTotalItem: TFloatField
      FieldName = 'valorTotalItem'
      currency = True
    end
    object TOrdemServicovalorDescontoItem: TFloatField
      FieldName = 'valorDescontoItem'
      currency = True
    end
    object TOrdemServicovalorFinalItem: TFloatField
      FieldName = 'valorFinalItem'
      currency = True
    end
    object TOrdemServicovalorTotalProduto: TFloatField
      FieldName = 'valorTotalProduto'
      currency = True
    end
    object TOrdemServicovalorDescontoProduto: TFloatField
      FieldName = 'valorDescontoProduto'
      currency = True
    end
    object TOrdemServicovalorFinalProduto: TFloatField
      FieldName = 'valorFinalProduto'
      currency = True
    end
    object TOrdemServicovalorFinal: TFloatField
      FieldName = 'valorFinal'
      currency = True
    end
    object TOrdemServicovalorDescontoTotal: TFloatField
      FieldName = 'valorDescontoTotal'
      currency = True
    end
    object TOrdemServicovalorTotal: TFloatField
      FieldName = 'valorTotal'
      currency = True
    end
    object TOrdemServicovalorTotalCusto: TFloatField
      FieldName = 'valorTotalCusto'
      currency = True
    end
    object TOrdemServicovalorTotalCustoFuncionario: TFloatField
      FieldName = 'valorTotalCustoFuncionario'
      currency = True
    end
    object TOrdemServicovalorLucro: TFloatField
      FieldName = 'valorLucro'
      currency = True
    end
    object TOrdemServicovalorFinalCusto: TFloatField
      FieldName = 'valorFinalCusto'
      currency = True
    end
    object TOrdemServicovalorLucroPercentual: TFloatField
      FieldName = 'valorLucroPercentual'
      DisplayFormat = '###,###,###,##0.00'
    end
  end
  object DEmpresa: TDataSource
    DataSet = QEmpresa
    Left = 163
    Top = 66
  end
  object QEmpresa: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 162
    Top = 14
    object QEmpresacodigo: TIntegerField
      FieldName = 'codigo'
    end
    object QEmpresarazaoSocial: TStringField
      FieldName = 'razaoSocial'
      Size = 150
    end
  end
  object DTipoFrete: TDataSource
    DataSet = QTipoFrete
    Left = 242
    Top = 65
  end
  object QTipoFrete: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 244
    Top = 17
    object QTipoFretedescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
  end
  object DFinalidade: TDataSource
    DataSet = QFinalidade
    Left = 332
    Top = 63
  end
  object QFinalidade: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 332
    Top = 11
    object QFinalidadedescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
  end
  object DEndereco: TDataSource
    DataSet = QEndereco
    Left = 417
    Top = 64
  end
  object QEndereco: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 416
    Top = 14
    object QEnderecocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object QEnderecocodigoPessoa: TIntegerField
      FieldName = 'codigoPessoa'
    end
    object QEnderecocodigoTipoEndereco: TIntegerField
      FieldName = 'codigoTipoEndereco'
    end
    object QEnderecotipoEndereco: TStringField
      FieldName = 'tipoEndereco'
      Size = 150
    end
    object QEnderecocep: TStringField
      FieldName = 'cep'
      Size = 10
    end
    object QEnderecolongradouro: TStringField
      FieldName = 'longradouro'
      Size = 150
    end
    object QEndereconumero: TStringField
      FieldName = 'numero'
      Size = 10
    end
    object QEnderecobairro: TStringField
      FieldName = 'bairro'
      Size = 150
    end
    object QEnderecocomplemento: TStringField
      FieldName = 'complemento'
      Size = 150
    end
    object QEnderecoobservacao: TMemoField
      FieldName = 'observacao'
      BlobType = ftMemo
    end
    object QEnderecocodigoCidade: TIntegerField
      FieldName = 'codigoCidade'
    end
    object QEndereconomeCidade: TStringField
      FieldName = 'nomeCidade'
      Size = 150
    end
    object QEndereconomeEstado: TStringField
      FieldName = 'nomeEstado'
      Size = 150
    end
    object QEndereconomePais: TStringField
      FieldName = 'nomePais'
      Size = 150
    end
    object QEnderecoprioridade: TStringField
      FieldName = 'prioridade'
      Size = 1
    end
    object QEnderecocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object QEnderecoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object QEnderecodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object QEnderecodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object QEnderecostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
  object DItem: TDataSource
    DataSet = TItem
    Left = 59
    Top = 178
  end
  object TItem: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 58
    Top = 128
    object TItemcodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TItemordem: TIntegerField
      FieldName = 'ordem'
    end
    object TItemdescricao: TStringField
      FieldName = 'descricao'
      Size = 250
    end
    object TItemquantidade: TFloatField
      FieldName = 'quantidade'
      DisplayFormat = '###,###,###,##0.00'
    end
    object TItemvalorUnitario: TFloatField
      FieldName = 'valorUnitario'
      currency = True
    end
    object TItemvalorTotal: TFloatField
      FieldName = 'valorTotal'
      currency = True
    end
    object TItemdesconto: TFloatField
      FieldName = 'desconto'
      DisplayFormat = '###,###,###,##0.00 %'
    end
    object TItemvalorDesconto: TFloatField
      FieldName = 'valorDesconto'
      currency = True
    end
    object TItemvalorFinal: TFloatField
      FieldName = 'valorFinal'
      currency = True
    end
    object TItemcadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TItemalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TItemdataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TItemdataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TItemstatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
  object DProduto: TDataSource
    DataSet = TProduto
    Left = 163
    Top = 175
  end
  object TProduto: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 163
    Top = 125
    object TProdutocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TProdutoordem: TIntegerField
      FieldName = 'ordem'
    end
    object TProdutodescricao: TStringField
      FieldName = 'descricao'
      Size = 250
    end
    object TProdutounidade: TStringField
      FieldName = 'unidade'
      Size = 10
    end
    object TProdutoquantidade: TFloatField
      FieldName = 'quantidade'
      DisplayFormat = '###,###,###,##0.00'
    end
    object TProdutovalorUnitario: TFloatField
      FieldName = 'valorUnitario'
      currency = True
    end
    object TProdutovalorTotal: TFloatField
      FieldName = 'valorTotal'
      currency = True
    end
    object TProdutodesconto: TFloatField
      FieldName = 'desconto'
      DisplayFormat = '###,###,###,##0.00 %'
    end
    object TProdutovalorDesconto: TFloatField
      FieldName = 'valorDesconto'
      currency = True
    end
    object TProdutovalorFinal: TFloatField
      FieldName = 'valorFinal'
      currency = True
    end
    object TProdutocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TProdutoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TProdutodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TProdutodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TProdutostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
  object DUnidade: TDataSource
    DataSet = QUnidade
    Left = 245
    Top = 177
  end
  object QUnidade: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 244
    Top = 125
    object QUnidadedescricao: TStringField
      FieldName = 'descricao'
      Size = 50
    end
  end
  object DCusto: TDataSource
    DataSet = TCusto
    Left = 334
    Top = 175
  end
  object TCusto: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 334
    Top = 125
    object TCustocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TCustoordem: TIntegerField
      FieldName = 'ordem'
    end
    object TCustocodigoGrupo: TIntegerField
      FieldName = 'codigoGrupo'
    end
    object TCustodescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object TCustosubDescricao: TStringField
      FieldName = 'subDescricao'
      Size = 150
    end
    object TCustoquantidade: TFloatField
      FieldName = 'quantidade'
      DisplayFormat = '###,###,###,##0.00'
    end
    object TCustovalorUnitario: TFloatField
      FieldName = 'valorUnitario'
      currency = True
    end
    object TCustovalorTotal: TFloatField
      FieldName = 'valorTotal'
      currency = True
    end
    object TCustocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TCustoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TCustodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TCustodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TCustostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
  object DFuncionario: TDataSource
    DataSet = TFuncionario
    Left = 412
    Top = 174
  end
  object TFuncionario: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 413
    Top = 124
    object TFuncionariocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TFuncionarioordem: TIntegerField
      FieldName = 'ordem'
    end
    object TFuncionariocodigoFuncao: TIntegerField
      FieldName = 'codigoFuncao'
    end
    object TFuncionariodescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object TFuncionariocodigoFuncionario: TIntegerField
      FieldName = 'codigoFuncionario'
    end
    object TFuncionarionomeFuncionario: TStringField
      FieldName = 'nomeFuncionario'
      Size = 150
    end
    object TFuncionarioqtdeHoraNormal: TIntegerField
      FieldName = 'qtdeHoraNormal'
    end
    object TFuncionarioqtdeHora50: TIntegerField
      FieldName = 'qtdeHora50'
    end
    object TFuncionarioqtdeHora100: TIntegerField
      FieldName = 'qtdeHora100'
    end
    object TFuncionarioqtdeHoraAdNoturno: TIntegerField
      FieldName = 'qtdeHoraAdNoturno'
    end
    object TFuncionariovalorHoraNormal: TFloatField
      FieldName = 'valorHoraNormal'
      currency = True
    end
    object TFuncionariovalorHora50: TFloatField
      FieldName = 'valorHora50'
      currency = True
    end
    object TFuncionariovalorHora100: TFloatField
      FieldName = 'valorHora100'
      currency = True
    end
    object TFuncionariovalorHoraAdNoturno: TFloatField
      FieldName = 'valorHoraAdNoturno'
      currency = True
    end
    object TFuncionariovalorTotalNormal: TFloatField
      FieldName = 'valorTotalNormal'
      currency = True
    end
    object TFuncionariovalorTotal50: TFloatField
      FieldName = 'valorTotal50'
      currency = True
    end
    object TFuncionariovalorTotal100: TFloatField
      FieldName = 'valorTotal100'
      currency = True
    end
    object TFuncionariovalorTotalAdNoturno: TFloatField
      FieldName = 'valorTotalAdNoturno'
      currency = True
    end
    object TFuncionariovalorTotal: TFloatField
      FieldName = 'valorTotal'
      currency = True
    end
    object TFuncionariocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TFuncionarioalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TFuncionariodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TFuncionariodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TFuncionariostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
  object QValorTotal: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 57
    Top = 232
    object QValorTotaldescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object QValorTotalvalorBruto: TFloatField
      FieldName = 'valorBruto'
      currency = True
    end
    object QValorTotaldesconto: TFloatField
      FieldName = 'desconto'
      DisplayFormat = '###,###,###,##0.00 %'
      currency = True
    end
    object QValorTotalvalorFinal: TFloatField
      FieldName = 'valorFinal'
      currency = True
    end
  end
  object DValorTotal: TDataSource
    DataSet = QValorTotal
    Left = 55
    Top = 280
  end
  object QCustoTotal: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 162
    Top = 228
    object QCustoTotaldescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object QCustoTotalsubDescricao: TStringField
      FieldName = 'subDescricao'
      Size = 150
    end
    object QCustoTotalquantidade: TFloatField
      FieldName = 'quantidade'
      DisplayFormat = '###,###,###,##0.00'
    end
    object QCustoTotalvalorTotal: TFloatField
      FieldName = 'valorTotal'
      currency = True
    end
  end
  object DCustoTotal: TDataSource
    DataSet = QCustoTotal
    Left = 160
    Top = 276
  end
end
