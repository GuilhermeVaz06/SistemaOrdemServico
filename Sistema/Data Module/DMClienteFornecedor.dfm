object FDMClienteFornecedor: TFDMClienteFornecedor
  OldCreateOrder = False
  OnCreate = DataModuleCreate
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
      OnGetText = telefoneGetText
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
    object TClienteFornecedorsenha: TStringField
      FieldName = 'senha'
      Size = 250
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
    end
    object TOutroDocumentodocumento: TStringField
      FieldName = 'documento'
      OnGetText = TOutroDocumentodocumentoGetText
    end
    object TOutroDocumentomascaraCaracteres: TStringField
      FieldName = 'mascaraCaracteres'
      Size = 30
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
    object TOutroDocumentodataEmissao: TStringField
      FieldName = 'dataEmissao'
      Size = 10
    end
    object TOutroDocumentodataVencimento: TStringField
      FieldName = 'dataVencimento'
      Size = 10
    end
  end
  object DEndereco: TDataSource
    DataSet = TEndereco
    Left = 375
    Top = 68
  end
  object TEndereco: TFDMemTable
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
    Left = 374
    Top = 18
    object TEnderecocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TEnderecocodigoPessoa: TIntegerField
      FieldName = 'codigoPessoa'
    end
    object TEnderecocodigoTipoEndereco: TIntegerField
      FieldName = 'codigoTipoEndereco'
    end
    object TEnderecotipoEndereco: TStringField
      FieldName = 'tipoEndereco'
      Size = 150
    end
    object TEnderecocep: TStringField
      FieldName = 'cep'
      OnGetText = TEnderecocepGetText
      Size = 10
    end
    object TEnderecolongradouro: TStringField
      FieldName = 'longradouro'
      Size = 150
    end
    object TEndereconumero: TStringField
      FieldName = 'numero'
      Size = 10
    end
    object TEnderecobairro: TStringField
      FieldName = 'bairro'
      Size = 150
    end
    object TEnderecocomplemento: TStringField
      FieldName = 'complemento'
      Size = 150
    end
    object TEnderecoobservacao: TMemoField
      FieldName = 'observacao'
      OnGetText = MemoGetText
      BlobType = ftMemo
    end
    object TEnderecocodigoCidade: TIntegerField
      FieldName = 'codigoCidade'
    end
    object TEndereconomeCidade: TStringField
      FieldName = 'nomeCidade'
      Size = 150
    end
    object TEndereconomeEstado: TStringField
      FieldName = 'nomeEstado'
      Size = 150
    end
    object TEndereconomePais: TStringField
      FieldName = 'nomePais'
      Size = 150
    end
    object TEnderecoprioridade: TStringField
      FieldName = 'prioridade'
      Size = 1
    end
    object TEnderecocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TEnderecoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TEnderecodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TEnderecodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TEnderecostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
  object DPrioridade: TDataSource
    DataSet = QPrioridade
    Left = 60
    Top = 176
  end
  object QPrioridade: TFDMemTable
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
    Top = 126
    object QPrioridadecodigo: TStringField
      FieldName = 'codigo'
      Size = 1
    end
    object QPrioridadedescricao: TStringField
      FieldName = 'descricao'
      Size = 50
    end
  end
  object DContato: TDataSource
    DataSet = TContato
    Left = 172
    Top = 176
  end
  object TContato: TFDMemTable
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
    Left = 172
    Top = 127
    object TContatocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TContatocodigoPessoa: TIntegerField
      FieldName = 'codigoPessoa'
    end
    object TContatocodigoTipoDocumento: TIntegerField
      FieldName = 'codigoTipoDocumento'
    end
    object TContatotipoDocumento: TStringField
      FieldName = 'tipoDocumento'
    end
    object TContatomascaraCararteres: TStringField
      FieldName = 'mascaraCararteres'
      Size = 30
    end
    object TContatodocumento: TStringField
      FieldName = 'documento'
      OnGetText = TContatodocumentoGetText
    end
    object TContatonome: TStringField
      FieldName = 'nome'
      Size = 150
    end
    object TContatodataNascimento: TStringField
      FieldName = 'dataNascimento'
      Size = 10
    end
    object TContatofuncao: TStringField
      FieldName = 'funcao'
      Size = 150
    end
    object TContatotelefone: TStringField
      FieldName = 'telefone'
      OnGetText = telefoneGetText
    end
    object TContatoemail: TStringField
      FieldName = 'email'
      Size = 250
    end
    object TContatoobservacao: TMemoField
      FieldName = 'observacao'
      OnGetText = MemoGetText
      BlobType = ftMemo
    end
    object TContatocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TContatoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TContatodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TContatodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TContatostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
end
