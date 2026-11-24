-- CreateEnum
CREATE TYPE "Papel" AS ENUM ('SOLICITANTE', 'ATENDENTE');

-- CreateEnum
CREATE TYPE "StatusChamado" AS ENUM ('PROPOSTO', 'CONFIRMADO', 'CORRIGIDO', 'REJEITADO');

-- CreateEnum
CREATE TYPE "OrigemResumo" AS ENUM ('IA', 'HUMANO');

-- CreateEnum
CREATE TYPE "AcaoRevisao" AS ENUM ('CONFIRMAR', 'CORRIGIR', 'REJEITAR');

-- CreateTable
CREATE TABLE "Usuario" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "papel" "Papel" NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Chamado" (
    "id" TEXT NOT NULL,
    "textoOriginal" TEXT NOT NULL,
    "status" "StatusChamado" NOT NULL DEFAULT 'PROPOSTO',
    "solicitanteId" TEXT NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Chamado_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Resumo" (
    "id" TEXT NOT NULL,
    "chamadoId" TEXT NOT NULL,
    "versao" INTEGER NOT NULL,
    "origem" "OrigemResumo" NOT NULL,
    "titulo" TEXT NOT NULL,
    "texto" TEXT NOT NULL,
    "pontosImportantes" TEXT[],
    "revisaoHumana" BOOLEAN NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Resumo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Revisao" (
    "id" TEXT NOT NULL,
    "chamadoId" TEXT NOT NULL,
    "autorId" TEXT NOT NULL,
    "acao" "AcaoRevisao" NOT NULL,
    "motivo" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Revisao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExecucaoIa" (
    "id" TEXT NOT NULL,
    "chamadoId" TEXT,
    "operacao" TEXT NOT NULL,
    "modelo" TEXT NOT NULL,
    "versaoPrompt" TEXT NOT NULL,
    "duracaoMs" INTEGER NOT NULL,
    "tokensEntrada" INTEGER,
    "tokensSaida" INTEGER,
    "validacaoOk" BOOLEAN NOT NULL,
    "categoriaErro" TEXT,
    "etapaFalha" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ExecucaoIa_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_email_key" ON "Usuario"("email");

-- CreateIndex
CREATE INDEX "Chamado_solicitanteId_criadoEm_idx" ON "Chamado"("solicitanteId", "criadoEm");

-- CreateIndex
CREATE UNIQUE INDEX "Resumo_chamadoId_versao_key" ON "Resumo"("chamadoId", "versao");

-- AddForeignKey
ALTER TABLE "Chamado" ADD CONSTRAINT "Chamado_solicitanteId_fkey" FOREIGN KEY ("solicitanteId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Resumo" ADD CONSTRAINT "Resumo_chamadoId_fkey" FOREIGN KEY ("chamadoId") REFERENCES "Chamado"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Revisao" ADD CONSTRAINT "Revisao_chamadoId_fkey" FOREIGN KEY ("chamadoId") REFERENCES "Chamado"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Revisao" ADD CONSTRAINT "Revisao_autorId_fkey" FOREIGN KEY ("autorId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExecucaoIa" ADD CONSTRAINT "ExecucaoIa_chamadoId_fkey" FOREIGN KEY ("chamadoId") REFERENCES "Chamado"("id") ON DELETE SET NULL ON UPDATE CASCADE;
