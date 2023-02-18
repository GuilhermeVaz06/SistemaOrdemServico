object FDMClienteFornecedor: TFDMClienteFornecedor
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DClienteFornecedor: TDataSource
    DataSet = TClienteFornecedor
    Left = 60
    Top = 67
  end
  object TClienteFornecedor: TFDMemTable
    AfterScroll = TClienteFornecedorAfterScroll
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
    object TClienteFornecedorcodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TClienteFornecedorcodigoTipoDocumento: TIntegerField
      FieldName = 'codigoTipoDocumento'
    end
    object TClienteFornecedortipoDocumento: TStringField
      FieldName = 'tipoDocumento'
      Size = 10
    end
    object TClienteFornecedorqtdeCaracteres: TIntegerField
      FieldName = 'qtdeCaracteres'
    end
    object TClienteFornecedormascaraCaracteres: TStringField
      FieldName = 'mascaraCaracteres'
      Size = 30
    end
    object TClienteFornecedordocumento: TStringField
      FieldName = 'documento'
      OnGetText = TClienteFornecedordocumentoGetText
    end
    object TClienteFornecedorrazaoSocial: TStringField
      FieldName = 'razaoSocial'
      Size = 150
    end
    object TClienteFornecedornomeFantasia: TStringField
      FieldName = 'nomeFantasia'
      Size = 150
    end
    object TClienteFornecedortelefone: TStringField
      FieldName = 'telefone'
      OnGetText = TClienteFornecedortelefoneGetText
    end
    object TClienteFornecedoremail: TStringField
      FieldName = 'email'
      Size = 250
    end
    object TClienteFornecedorobservacao: TMemoField
      FieldName = 'observacao'
      OnGetText = MemoGetText
      BlobType = ftMemo
    end
    object TClienteFornecedorstatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TClienteFornecedorcadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TClienteFornecedoralteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TClienteFornecedordataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TClienteFornecedordataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
  object DTipoDocumento: TDataSource
    DataSet = QTipoDocumento
    Left = 174
    Top = 69
  end
  object QTipoDocumento: TFDMemTable
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
    Left = 173
    Top = 19
    object QTipoDocumentocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object QTipoDocumentodescricao: TStringField
      FieldName = 'descricao'
      Size = 10
    end
    object QTipoDocumentoqtdeCaracteres: TIntegerField
      FieldName = 'qtdeCaracteres'
    end
    object QTipoDocumentomascara: TStringField
      FieldName = 'mascara'
      Size = 30
    end
    object QTipoDocumentostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object QTipoDocumentocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object QTipoDocumentoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object QTipoDocumentodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object QTipoDocumentodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
  object DOutroDocumento: TDataSource
    DataSet = TOutroDocumento
    Left = 275
    Top = 68
  end
  object TOutroDocumento: TFDMemTable
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
    Left = 274
    Top = 18
    object TOutroDocumentocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TOutroDocumentocodigoPessoa: TIntegerField
      FieldName = 'codigoPessoa'
    end
    object TOutroDocumentocodigoTipoDocumento: TIntegerField
      FieldName = 'codigoTipoDocumento'
    end
    object TOutroDocumentoTipoDocumento: TStringField
      FieldName = 'TipoDocumento'
      Size = 10
    end
    object TOutroDocumentodocumento: TStringField
      FieldName = 'documento'
    end
    object TOutroDocumentodataEmissao: TDateField
      FieldName = 'dataEmissao'
    end
    object TOutroDocumentodataVencimento: TDateField
      FieldName = 'dataVencimento'
    end
    object TOutroDocumentoobservacao: TMemoField
      FieldName = 'observacao'
      OnGetText = MemoGetText
      BlobType = ftMemo
    end
    object TOutroDocumentostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TOutroDocumentocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TOutroDocumentoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TOutroDocumentodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TOutroDocumentodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
end
