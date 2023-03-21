object FDMOrdemServico: TFDMOrdemServico
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DOrdemServico: TDataSource
    DataSet = TOrdemServico
    Left = 60
    Top = 67
  end
  object TOrdemServico: TFDMemTable
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
      Size = 8
    end
    object TOrdemServicodataOrdemServico: TStringField
      FieldName = 'dataOrdemServico'
      Size = 8
    end
    object TOrdemServicodesconto: TFloatField
      FieldName = 'desconto'
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
  end
end
