object FDMCliente: TFDMCliente
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DCliente: TDataSource
    DataSet = TCliente
    Left = 34
    Top = 67
  end
  object TCliente: TFDMemTable
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
    Left = 33
    Top = 17
    object TClientecodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TClientecodigoTipoDocumento: TIntegerField
      FieldName = 'codigoTipoDocumento'
    end
    object TClientetipoDocumento: TStringField
      FieldName = 'tipoDocumento'
      Size = 10
    end
    object TClienteqtdeCaracteres: TIntegerField
      FieldName = 'qtdeCaracteres'
    end
    object TClientemascaraCaracteres: TStringField
      FieldName = 'mascaraCaracteres'
      Size = 30
    end
    object TClientedocumento: TStringField
      FieldName = 'documento'
      OnGetText = TClientedocumentoGetText
    end
    object TClienterazaoSocial: TStringField
      FieldName = 'razaoSocial'
      Size = 150
    end
    object TClientenomeFantasia: TStringField
      FieldName = 'nomeFantasia'
      Size = 150
    end
    object TClientetelefone: TStringField
      FieldName = 'telefone'
      OnGetText = TClientetelefoneGetText
    end
    object TClienteemail: TStringField
      FieldName = 'email'
      Size = 250
    end
    object TClienteobservacao: TMemoField
      FieldName = 'observacao'
      OnGetText = MemoGetText
      BlobType = ftMemo
    end
    object TClientestatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TClientecadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TClientealteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TClientedataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TClientedataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
  object DTipoDocumento: TDataSource
    DataSet = QTipoDocumento
    Left = 106
    Top = 66
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
    Left = 105
    Top = 16
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
end
