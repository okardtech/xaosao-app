// To parse this JSON data, do
//
//     final referralModel = referralModelFromJson(jsonString);

import 'dart:convert';

ReferralModel referralModelFromJson(String str) => ReferralModel.fromJson(json.decode(str));

String referralModelToJson(ReferralModel data) => json.encode(data.toJson());

class ReferralModel {
    String? modelName;
    String? modelProfile;
    String? modelType;
    String? referralCode;
    String? referralLink;
    String? customerReferralCode;
    String? customerReferralLink;
    bool? commissionEligible;
    String? commissionEligibilityReason;
    Stats? stats;
    UpgradeProgress? upgradeProgress;

    ReferralModel({
        this.modelName,
        this.modelProfile,
        this.modelType,
        this.referralCode,
        this.referralLink,
        this.customerReferralCode,
        this.customerReferralLink,
        this.commissionEligible,
        this.commissionEligibilityReason,
        this.stats,
        this.upgradeProgress,
    });

    factory ReferralModel.fromJson(Map<String, dynamic> json) => ReferralModel(
        modelName: json["modelName"],
        modelProfile: json["modelProfile"],
        modelType: json["modelType"],
        referralCode: json["referralCode"],
        referralLink: json["referralLink"],
        customerReferralCode: json["customerReferralCode"],
        customerReferralLink: json["customerReferralLink"],
        commissionEligible: json["commissionEligible"],
        commissionEligibilityReason: json["commissionEligibilityReason"],
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        upgradeProgress: json["upgradeProgress"] == null ? null : UpgradeProgress.fromJson(json["upgradeProgress"]),
    );

    Map<String, dynamic> toJson() => {
        "modelName": modelName,
        "modelProfile": modelProfile,
        "modelType": modelType,
        "referralCode": referralCode,
        "referralLink": referralLink,
        "customerReferralCode": customerReferralCode,
        "customerReferralLink": customerReferralLink,
        "commissionEligible": commissionEligible,
        "commissionEligibilityReason": commissionEligibilityReason,
        "stats": stats?.toJson(),
        "upgradeProgress": upgradeProgress?.toJson(),
    };
}

class Stats {
    int? totalReferredModels;
    int? approvedReferredModels;
    int? pendingReferredModels;
    int? totalReferredCustomers;
    int? activeReferredCustomers;
    int? modelReferralEarnings;
    int? bookingCommissionEarnings;
    int? subscriptionCommissionEarnings;
    int? totalCommissionEarnings;
    int? totalEarnings;

    Stats({
        this.totalReferredModels,
        this.approvedReferredModels,
        this.pendingReferredModels,
        this.totalReferredCustomers,
        this.activeReferredCustomers,
        this.modelReferralEarnings,
        this.bookingCommissionEarnings,
        this.subscriptionCommissionEarnings,
        this.totalCommissionEarnings,
        this.totalEarnings,
    });

    factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        totalReferredModels: json["totalReferredModels"],
        approvedReferredModels: json["approvedReferredModels"],
        pendingReferredModels: json["pendingReferredModels"],
        totalReferredCustomers: json["totalReferredCustomers"],
        activeReferredCustomers: json["activeReferredCustomers"],
        modelReferralEarnings: json["modelReferralEarnings"],
        bookingCommissionEarnings: json["bookingCommissionEarnings"],
        subscriptionCommissionEarnings: json["subscriptionCommissionEarnings"],
        totalCommissionEarnings: json["totalCommissionEarnings"],
        totalEarnings: json["totalEarnings"],
    );

    Map<String, dynamic> toJson() => {
        "totalReferredModels": totalReferredModels,
        "approvedReferredModels": approvedReferredModels,
        "pendingReferredModels": pendingReferredModels,
        "totalReferredCustomers": totalReferredCustomers,
        "activeReferredCustomers": activeReferredCustomers,
        "modelReferralEarnings": modelReferralEarnings,
        "bookingCommissionEarnings": bookingCommissionEarnings,
        "subscriptionCommissionEarnings": subscriptionCommissionEarnings,
        "totalCommissionEarnings": totalCommissionEarnings,
        "totalEarnings": totalEarnings,
    };
}

class UpgradeProgress {
    int? modelThreshold;
    int? earningsThreshold;
    int? currentApprovedModels;
    int? currentCommissionEarnings;
    int? modelsUntilSpecial;
    int? specialProgress;
    int? modelsUntilPartner;
    int? earningsUntilPartner;
    int? partnerModelProgress;
    int? partnerEarningsProgress;
    bool? canUpgradeToSpecial;
    bool? canUpgradeToPartner;

    UpgradeProgress({
        this.modelThreshold,
        this.earningsThreshold,
        this.currentApprovedModels,
        this.currentCommissionEarnings,
        this.modelsUntilSpecial,
        this.specialProgress,
        this.modelsUntilPartner,
        this.earningsUntilPartner,
        this.partnerModelProgress,
        this.partnerEarningsProgress,
        this.canUpgradeToSpecial,
        this.canUpgradeToPartner,
    });

    factory UpgradeProgress.fromJson(Map<String, dynamic> json) => UpgradeProgress(
        modelThreshold: json["modelThreshold"],
        earningsThreshold: json["earningsThreshold"],
        currentApprovedModels: json["currentApprovedModels"],
        currentCommissionEarnings: json["currentCommissionEarnings"],
        modelsUntilSpecial: json["modelsUntilSpecial"],
        specialProgress: json["specialProgress"],
        modelsUntilPartner: json["modelsUntilPartner"],
        earningsUntilPartner: json["earningsUntilPartner"],
        partnerModelProgress: json["partnerModelProgress"],
        partnerEarningsProgress: json["partnerEarningsProgress"],
        canUpgradeToSpecial: json["canUpgradeToSpecial"],
        canUpgradeToPartner: json["canUpgradeToPartner"],
    );

    Map<String, dynamic> toJson() => {
        "modelThreshold": modelThreshold,
        "earningsThreshold": earningsThreshold,
        "currentApprovedModels": currentApprovedModels,
        "currentCommissionEarnings": currentCommissionEarnings,
        "modelsUntilSpecial": modelsUntilSpecial,
        "specialProgress": specialProgress,
        "modelsUntilPartner": modelsUntilPartner,
        "earningsUntilPartner": earningsUntilPartner,
        "partnerModelProgress": partnerModelProgress,
        "partnerEarningsProgress": partnerEarningsProgress,
        "canUpgradeToSpecial": canUpgradeToSpecial,
        "canUpgradeToPartner": canUpgradeToPartner,
    };
}
